#!/usr/bin/env python3
"""
Preview Excel file structure
"""
import pandas as pd

# Read the Excel file
excel_file = 'IT Hardware Inventory (3).xlsx'

# Get all sheet names
xl = pd.ExcelFile(excel_file)
print(f"📊 Excel file: {excel_file}")
print(f"📄 Sheets found: {xl.sheet_names}\n")

# Read the first sheet
df = pd.read_excel(excel_file, sheet_name=xl.sheet_names[0])

print(f"📋 Sheet: {xl.sheet_names[0]}")
print(f"📏 Rows: {len(df)}, Columns: {len(df.columns)}\n")

print("📌 Column names:")
for i, col in enumerate(df.columns, 1):
    print(f"  {i}. {col}")

print("\n📝 First 3 rows preview:")
print(df.head(3).to_string())

print(f"\n📊 Data types:")
print(df.dtypes)
