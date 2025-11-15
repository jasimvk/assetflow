#!/usr/bin/env python3
"""
Convert Excel sheets to CSV for easy import
"""
import pandas as pd
import os
from datetime import datetime

# Create output directory
os.makedirs('csv_export', exist_ok=True)

excel_file = 'IT Hardware Inventory (3).xlsx'
xl = pd.ExcelFile(excel_file)

print("📦 Converting Excel sheets to CSV...")
print("=" * 60)

# Category mapping
CATEGORY_MAPPING = {
    'Server': 'IT Equipment - Server',
    'Switch': 'IT Equipment - Switch',
    'Storage': 'IT Equipment - Storage',
    'Laptop': 'IT Equipment - Laptop',
    'Desktop': 'IT Equipment - Desktop',
    'Monitor': 'IT Equipment - Monitor',
    'Mobile Phones': 'IT Equipment - Mobile',
    'Walkie Talkie': 'IT Equipment - Walkie Talkie',
    'Tablet': 'IT Equipment - Tablet',
    'Printer': 'IT Equipment - Printer',
    'iPhones': 'IT Equipment - iPhone',
    'IT Peripherals': 'IT Equipment - Peripherals'
}

all_assets = []

for sheet_name in xl.sheet_names:
    # Skip sheets we don't want
    if sheet_name in ['Windows 10 Upgrade Pending', 'Sheet1', 'Sheet2']:
        continue
    
    try:
        df = pd.read_excel(excel_file, sheet_name=sheet_name)
        
        # Get category
        category = CATEGORY_MAPPING.get(sheet_name, 'Other')
        
        for index, row in df.iterrows():
            asset_name = row.get('Asset Name')
            if pd.isna(asset_name) or str(asset_name).strip() == '':
                continue
            
            # Extract data
            location = row.get('Location', 'Unknown')
            if pd.isna(location):
                location = 'Unknown'
            
            model = row.get('Model Name', '')
            serial_no = row.get('Serial No', '')
            purchase_year = row.get('Year Of Purchase')
            warranty_end = row.get('Warranty end')
            
            # Build description
            desc_parts = []
            if not pd.isna(model):
                desc_parts.append(f"Model: {model}")
            if not pd.isna(serial_no):
                desc_parts.append(f"Serial: {serial_no}")
            if 'Configuration' in row and not pd.isna(row['Configuration']):
                desc_parts.append(str(row['Configuration']))
            if 'IP Address' in row and not pd.isna(row['IP Address']):
                desc_parts.append(f"IP: {row['IP Address']}")
            
            description = " | ".join(desc_parts) if desc_parts else ''
            
            # Handle purchase date
            if not pd.isna(purchase_year):
                if hasattr(purchase_year, 'year'):
                    purchase_date = purchase_year.strftime('%Y-%m-%d')
                    years_old = datetime.now().year - purchase_year.year
                else:
                    try:
                        year = int(purchase_year)
                        purchase_date = f"{year}-01-01"
                        years_old = datetime.now().year - year
                    except:
                        purchase_date = '2020-01-01'
                        years_old = 5
            else:
                purchase_date = '2020-01-01'
                years_old = 5
            
            # Estimate values
            purchase_cost = 1000
            current_value = max(purchase_cost * (1 - years_old * 0.2), 100)
            
            # Determine condition
            if years_old <= 1:
                condition = 'excellent'
            elif years_old <= 3:
                condition = 'good'
            elif years_old <= 5:
                condition = 'fair'
            else:
                condition = 'poor'
            
            asset = {
                'name': str(asset_name).strip(),
                'category': category,
                'location': str(location).strip(),
                'purchase_date': purchase_date,
                'purchase_cost': purchase_cost,
                'current_value': round(current_value, 2),
                'condition': condition,
                'assigned_to': '',
                'description': description
            }
            
            all_assets.append(asset)
        
        print(f"✅ Processed: {sheet_name} ({len([a for a in all_assets if a['category'] == category])} assets)")
    
    except Exception as e:
        print(f"❌ Error processing {sheet_name}: {str(e)}")

# Create master CSV
if all_assets:
    df_all = pd.DataFrame(all_assets)
    csv_file = 'csv_export/all_assets.csv'
    df_all.to_csv(csv_file, index=False)
    print("\n" + "=" * 60)
    print(f"✨ Success! Created CSV with {len(all_assets)} assets")
    print(f"📁 File: {csv_file}")
    print("\n📋 You can now:")
    print("   1. Open Supabase Dashboard")
    print("   2. Go to Table Editor > assets table")
    print("   3. Click 'Insert' > 'Import data from CSV'")
    print("   4. Upload the CSV file")
    print("=" * 60)
else:
    print("\n❌ No assets found to export")
