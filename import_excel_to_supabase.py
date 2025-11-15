#!/usr/bin/env python3
"""
Import IT Hardware Inventory from Excel to Supabase
"""
import pandas as pd
import os
from supabase import create_client
from dotenv import load_dotenv
from datetime import datetime

# Load environment variables
load_dotenv('frontend/.env.local')

# Supabase credentials
SUPABASE_URL = os.getenv('NEXT_PUBLIC_SUPABASE_URL')
SUPABASE_KEY = os.getenv('NEXT_PUBLIC_SUPABASE_ANON_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Error: Supabase credentials not found!")
    print("Please set NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY in frontend/.env.local")
    exit(1)

# Initialize Supabase client
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# Category mapping for different sheets
CATEGORY_MAPPING = {
    'Server': 'IT Equipment',
    'Switch': 'IT Equipment',
    'Storage': 'IT Equipment',
    'Laptop': 'IT Equipment',
    'Desktop': 'IT Equipment',
    'Monitor': 'IT Equipment',
    'Mobile Phones': 'IT Equipment',
    'Walkie Talkie': 'IT Equipment',
    'Tablet': 'IT Equipment',
    'Printer': 'IT Equipment',
    'iPhones': 'IT Equipment',
    'IT Peripherals': 'IT Equipment'
}

def clean_value(value):
    """Clean and convert values"""
    if pd.isna(value):
        return None
    if isinstance(value, str):
        return value.strip()
    return value

def estimate_current_value(purchase_year, original_cost=None):
    """Estimate current value based on depreciation"""
    if pd.isna(purchase_year):
        return 0
    
    try:
        current_year = datetime.now().year
        years_old = current_year - int(purchase_year.year if hasattr(purchase_year, 'year') else purchase_year)
        
        # Depreciation: 20% per year for IT equipment
        if original_cost:
            depreciation = 0.20 * years_old
            current_value = original_cost * (1 - min(depreciation, 0.80))  # Max 80% depreciation
        else:
            # Estimate based on category
            current_value = max(500 - (years_old * 100), 100)  # Minimum $100
        
        return round(current_value, 2)
    except:
        return 0

def determine_condition(purchase_year, warranty_end):
    """Determine condition based on age and warranty"""
    try:
        current_year = datetime.now().year
        
        # Check warranty
        if not pd.isna(warranty_end):
            if warranty_end.year >= current_year:
                return 'excellent'
        
        # Check age
        if not pd.isna(purchase_year):
            years_old = current_year - int(purchase_year.year if hasattr(purchase_year, 'year') else purchase_year)
            if years_old <= 1:
                return 'excellent'
            elif years_old <= 3:
                return 'good'
            elif years_old <= 5:
                return 'fair'
            else:
                return 'poor'
    except:
        pass
    
    return 'good'  # Default

def process_sheet(sheet_name, df):
    """Process a single sheet and import to Supabase"""
    print(f"\n📄 Processing sheet: {sheet_name}")
    print(f"   Rows: {len(df)}")
    
    # Get category
    category = CATEGORY_MAPPING.get(sheet_name, 'Other')
    
    assets_to_insert = []
    
    for index, row in df.iterrows():
        # Skip empty rows
        asset_name = clean_value(row.get('Asset Name'))
        if not asset_name:
            continue
        
        # Extract data
        location = clean_value(row.get('Location', 'Unknown'))
        model = clean_value(row.get('Model Name'))
        serial_no = clean_value(row.get('Serial No'))
        purchase_year = row.get('Year Of Purchase')
        warranty_end = row.get('Warranty end')
        
        # Build description
        description_parts = []
        if model:
            description_parts.append(f"Model: {model}")
        if serial_no:
            description_parts.append(f"Serial: {serial_no}")
        if 'Configuration' in row and clean_value(row['Configuration']):
            description_parts.append(clean_value(row['Configuration']))
        if 'IP Address' in row and clean_value(row['IP Address']):
            description_parts.append(f"IP: {clean_value(row['IP Address'])}")
        
        description = " | ".join(description_parts) if description_parts else None
        
        # Determine values
        if not pd.isna(purchase_year):
            if hasattr(purchase_year, 'strftime'):
                purchase_date = purchase_year.strftime('%Y-%m-%d')
            else:
                # If it's already a string or number, try to convert
                try:
                    year = int(purchase_year)
                    purchase_date = f"{year}-01-01"
                except:
                    purchase_date = '2020-01-01'
        else:
            purchase_date = '2020-01-01'
        
        purchase_cost = 1000  # Default estimate
        current_value = estimate_current_value(purchase_year, purchase_cost)
        condition = determine_condition(purchase_year, warranty_end)
        
        # Create asset object
        asset = {
            'name': asset_name,
            'category': f"{category} - {sheet_name}",
            'location': location or 'Unknown',
            'purchase_date': purchase_date,
            'purchase_cost': purchase_cost,
            'current_value': current_value,
            'condition': condition,
            'assigned_to': None,
            'description': description
        }
        
        assets_to_insert.append(asset)
    
    # Insert into Supabase
    if assets_to_insert:
        try:
            result = supabase.table('assets').insert(assets_to_insert).execute()
            print(f"   ✅ Inserted {len(assets_to_insert)} assets")
            return len(assets_to_insert)
        except Exception as e:
            print(f"   ❌ Error inserting assets: {str(e)}")
            return 0
    else:
        print(f"   ⚠️  No assets to insert")
        return 0

def main():
    """Main import function"""
    print("🚀 Starting IT Hardware Inventory Import")
    print("=" * 60)
    
    excel_file = 'IT Hardware Inventory (3).xlsx'
    
    # Read Excel file
    xl = pd.ExcelFile(excel_file)
    
    total_imported = 0
    
    # Process each sheet
    for sheet_name in xl.sheet_names:
        # Skip sheets we don't want to process
        if sheet_name in ['Windows 10 Upgrade Pending', 'Sheet1', 'Sheet2']:
            print(f"\n⏭️  Skipping sheet: {sheet_name}")
            continue
        
        try:
            df = pd.read_excel(excel_file, sheet_name=sheet_name)
            imported = process_sheet(sheet_name, df)
            total_imported += imported
        except Exception as e:
            print(f"\n❌ Error processing sheet {sheet_name}: {str(e)}")
    
    print("\n" + "=" * 60)
    print(f"✨ Import completed! Total assets imported: {total_imported}")

if __name__ == '__main__':
    main()
