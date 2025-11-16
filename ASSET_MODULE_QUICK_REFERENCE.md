# Asset Management Module - Quick Reference Guide

## 🎯 Overview
Complete asset management system with advanced features including bulk operations, filtering, export, and comprehensive asset tracking.

---

## 📋 Key Features

### 1. Asset CRUD Operations
- **Create**: Click "Add New Asset" button
- **Read**: View in table or click asset name for details
- **Update**: Click Edit icon or edit from detail view
- **Delete**: Click trash icon (single) or use bulk delete

### 2. Search & Filtering
```
Search Box: Text search across name, serial, model, manufacturer
Category Filter: 12 asset categories
Location Filter: All locations from database
Status Filter: active, in_stock, maintenance, retired, disposed
Condition Filter: excellent, good, fair, poor
Clear Filters Button: Reset all filters at once
```

### 3. Bulk Operations
```
1. Check boxes next to assets you want to select
2. Use "Select All" checkbox in header to select all visible assets
3. Click "Delete Selected" button in the selection bar
4. Confirm deletion
```

### 4. Export Data
```
1. Apply any filters you want
2. Click "Export CSV" button in top right
3. CSV file downloads with filtered assets
4. Filename format: assets-YYYY-MM-DD.csv
```

### 5. Asset Form Fields

#### Basic Information (Section 1)
- **Asset Name*** - Required text field
- **Category*** - Required dropdown (12 options)
- **Location*** - Required dropdown (from database)
- **Serial Number** - Optional text field
- **Model** - Optional text field
- **Manufacturer** - Optional text field
- **Status*** - Required dropdown (5 options)

#### Financial Information (Section 2)
- **Purchase Cost*** - Required number field
- **Current Value*** - Required number field
- **Purchase Date*** - Required date field

#### Condition & Assignment (Section 3)
- **Condition*** - Required dropdown (4 options)
- **Warranty Expiry** - Optional date field
- **Maintenance Schedule** - Optional dropdown (weekly to annually)
- **Assigned To** - Optional text field

#### Additional Information (Section 4)
- **Description** - Optional textarea
- **Notes** - Optional textarea

---

## 🎨 Color Coding

### Status Badges
| Status | Color | Description |
|--------|-------|-------------|
| Active | 🟢 Green | Asset is in use |
| In Stock | 🔵 Blue | Asset is available |
| Maintenance | 🟡 Yellow | Under maintenance |
| Retired | ⚪ Gray | No longer in service |
| Disposed | 🔴 Red | Removed from inventory |

### Condition Badges
| Condition | Color | Description |
|-----------|-------|-------------|
| Excellent | 🟢 Green | Like new |
| Good | 🔵 Blue | Working well |
| Fair | 🟡 Yellow | Needs attention |
| Poor | 🔴 Red | Requires repair/replacement |

---

## 🔍 Search Tips

### Quick Search
- Type in search box to find assets by:
  - Asset name
  - Serial number
  - Model
  - Manufacturer

### Advanced Filtering
1. Use category filter to see specific asset types
2. Use location filter to find assets in specific locations
3. Use status filter to see only active/retired/etc assets
4. Use condition filter to find assets needing attention
5. Combine all filters for precise results

### Example Searches
```
"Find all laptops in poor condition in Office - Floor 1"
1. Select Category: Laptop
2. Select Condition: Poor
3. Select Location: Office - Floor 1

"Find all active servers"
1. Select Category: Server
2. Select Status: Active

"Export all maintenance assets"
1. Select Status: Maintenance
2. Click Export CSV
```

---

## 📊 Statistics Dashboard

The top dashboard shows 4 key metrics:

1. **Total Assets** - All assets in system
2. **Total Value** - Sum of current_value of all assets
3. **Active** - Count of active assets
4. **Assigned** - Count of assets assigned to users

---

## ⚡ Quick Actions

### From Table View
- **View Details**: Click asset name or eye icon
- **Edit**: Click edit icon
- **Delete**: Click trash icon
- **Select**: Check checkbox

### From Detail View
- **Edit Asset**: Click "Edit Asset" button
- **Close**: Click "Close" button or X icon

### Keyboard Shortcuts
- `Esc` - Close any open modal
- `Enter` - Submit form (when form is focused)

---

## ✅ Best Practices

### Adding Assets
1. Always fill required fields (marked with *)
2. Add serial numbers for tracking
3. Set appropriate status
4. Add descriptive notes for future reference
5. Set warranty expiry for important assets
6. Assign maintenance schedule for critical equipment

### Organizing Assets
1. Use consistent naming conventions
2. Keep locations up to date
3. Update status as assets change
4. Update current value periodically
5. Document condition changes in notes

### Using Bulk Operations
1. Filter first to narrow selection
2. Review selected assets before deleting
3. Consider exporting before bulk delete
4. Use bulk operations for efficiency

---

## 🚨 Important Notes

### Required Fields
- Asset Name
- Category
- Location
- Purchase Cost (can be 0)
- Current Value (can be 0)
- Purchase Date
- Condition
- Status

### Validation
- Form validates before submission
- Alerts show success/error messages
- Delete operations require confirmation
- Bulk delete shows count before confirmation

### Data Integrity
- Serial numbers don't have to be unique
- Assigned To is free text (not linked to users table)
- Status defaults to "active" if not set
- All currency values must be non-negative

---

## 🔧 Troubleshooting

### Asset Not Showing in Table
1. Check your filters - clear all filters to see all assets
2. Check search box - clear search term
3. Refresh the page

### Can't Delete Asset
1. Confirm you have permissions
2. Check for error messages in console
3. Try refreshing and deleting again

### Form Won't Submit
1. Check all required fields are filled
2. Look for red error messages
3. Ensure dates are in correct format
4. Verify numeric fields have valid numbers

### Export Not Working
1. Check if you have assets in filtered view
2. Ensure popup blocker isn't blocking download
3. Check browser's download folder

---

## 📱 Mobile Usage

### On Small Screens
- Filters stack vertically
- Table scrolls horizontally
- Modals adapt to screen size
- Touch-friendly buttons

### Tips
- Use landscape mode for better table view
- Pinch to zoom if needed
- Swipe to scroll table horizontally

---

## 🎓 Training Checklist

For new users, demonstrate:
- [ ] How to add a new asset
- [ ] How to search and filter
- [ ] How to edit an asset
- [ ] How to view asset details
- [ ] How to delete an asset
- [ ] How to use bulk operations
- [ ] How to export data
- [ ] Understanding status colors
- [ ] Understanding condition colors
- [ ] How to assign assets

---

## 📞 Support

If you encounter issues:
1. Check this guide
2. Clear your browser cache
3. Refresh the page
4. Check browser console for errors
5. Contact your system administrator

---

## 📈 Version Information

**Current Version**: 2.0
**Last Updated**: November 16, 2025
**Status**: Production Ready

---

**Quick Reference Card**: Print this section for desk reference

### Most Common Tasks
1. **Add Asset**: Top right "Add New Asset" button
2. **Find Asset**: Use search box or filters
3. **Edit Asset**: Click edit icon in table row
4. **Delete Asset**: Click trash icon in table row
5. **Export Data**: Top right "Export CSV" button
6. **Clear Filters**: "Clear Filters" button below search
