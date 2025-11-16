# Master Data Management Module

## Overview
The Master Data Management module provides a centralized interface for managing reference data used throughout the AssetFlow system.

## Features

### 1. Departments Management
- **Add/Edit/Delete** departments
- Track department head and location
- Enable/disable departments (is_active toggle)
- Display all departments in card grid layout
- **Fields:**
  - Name (required)
  - Description
  - Department Head
  - Location
  - Active Status

### 2. Categories Management
- **Add/Edit/Delete** asset categories
- Organize asset types
- Display categories in grid layout
- **Fields:**
  - Name (required)
  - Description

### 3. Locations Management
- **Add/Edit/Delete** physical locations
- Track detailed location information
- Display locations in card grid layout
- **Fields:**
  - Name (required)
  - Address
  - Building
  - Floor
  - Room

## Access

Navigate to **Master Data** from the sidebar menu

## User Interface

### Tabs Navigation
- Three tabs: Departments | Categories | Locations
- Shows count badge for each tab
- Active tab highlighted with primary color

### Card Grid Layout
- Responsive grid (1-3 columns)
- Each card shows:
  - Name and status/description
  - Edit and Delete buttons
  - Additional details (department head, location, etc.)

### Modals
- Clean modal dialogs for add/edit operations
- Form validation
- Save/Cancel buttons
- Loading states

## Database Integration

### Tables Used

**departments**
```sql
- id (UUID, PK)
- name (VARCHAR, UNIQUE)
- description (TEXT)
- department_head (VARCHAR)
- location (VARCHAR)
- is_active (BOOLEAN)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

**categories**
```sql
- id (UUID, PK)
- name (VARCHAR, UNIQUE)
- description (TEXT)
- created_at (TIMESTAMP)
```

**locations**
```sql
- id (UUID, PK)
- name (VARCHAR, UNIQUE)
- address (TEXT)
- building (VARCHAR)
- floor (VARCHAR)
- room (VARCHAR)
- created_at (TIMESTAMP)
```

## Operations

### Add Department
1. Click "Add Department" button
2. Fill in required name field
3. Optionally add description, department head, location
4. Toggle active status
5. Click Save

### Edit Department
1. Click edit icon on department card
2. Modify fields
3. Click Save

### Delete Department
1. Click delete icon on department card
2. Confirm deletion
3. Department removed (cascading deletes may apply to related assets)

### Same process applies to Categories and Locations

## Best Practices

### Departments
- Use clear, consistent naming (e.g., "IT", "HR", "Finance")
- Add descriptions to clarify department purpose
- Keep active departments enabled
- Disable instead of delete to maintain historical data

### Categories
- Match categories to actual asset types in inventory
- Use standard naming conventions
- Avoid duplicate or overlapping categories
- Examples: Laptop, Desktop, Monitor, Mobile Phone, Printer

### Locations
- Be specific with location names
- Include building/floor/room for larger facilities
- Use consistent naming format
- Examples: "Head Office", "Warehouse A", "Server Room 2F"

## Integration with Assets

### Department → Assets
- Assets table has `department_id` foreign key
- Frontend should join departments table when loading assets
- Department name displayed in assets table

### Category → Assets
- Assets have category field (text or foreign key)
- Used for filtering and grouping
- Critical for asset classification

### Location → Assets
- Assets have location field
- Used for physical tracking
- Important for inventory audits

## SQL Queries for Populating Master Data

### Run in Supabase SQL Editor:

```sql
-- Populate Departments
INSERT INTO departments (name, description, is_active) VALUES
('IT', 'Information Technology Department', true),
('HR', 'Human Resources Department', true),
('Finance', 'Finance and Accounting Department', true),
('Procurement', 'Procurement Department', true),
('F&B', 'Food & Beverage Department', true),
('Housekeeping', 'Housekeeping Department', true),
('Kitchen', 'Kitchen Department', true),
('Maintenance', 'Maintenance Department', true),
('Admin', 'Administration Department', true),
('Security', 'Security Department', true),
('Executive Office', 'Executive Office', true)
ON CONFLICT (name) DO NOTHING;

-- Populate Categories
INSERT INTO categories (name, description) VALUES
('Laptop', 'Laptop computers for mobile computing'),
('Desktop', 'Desktop computers and workstations'),
('Monitor', 'Display monitors'),
('Mobile Phone', 'Mobile phones and smartphones'),
('Tablet', 'Tablets and iPads'),
('Printer', 'Printers and multifunction devices'),
('Server', 'Server hardware'),
('Network Device', 'Routers, switches, and network equipment'),
('Peripheral', 'Keyboards, mice, and other peripherals'),
('Walkie Talkie', 'Two-way radios and communication devices')
ON CONFLICT (name) DO NOTHING;

-- Populate Locations
INSERT INTO locations (name, address, building) VALUES
('Head Office', 'Main Street 123', 'Main Building'),
('Warehouse', 'Industrial Road 456', 'Warehouse A'),
('Server Room', 'Main Street 123', 'Main Building - 2F'),
('Branch Office', 'Downtown Street 789', 'Branch Building')
ON CONFLICT (name) DO NOTHING;
```

## Troubleshooting

### Issue: "Failed to load departments"
**Solution:** Check Supabase connection and ensure departments table exists

### Issue: "Failed to delete department"
**Solution:** Check if department is referenced by assets. May need to cascade delete or reassign assets first.

### Issue: Duplicate names
**Solution:** Names are unique. Choose a different name or edit existing entry.

### Issue: Changes not reflecting
**Solution:** Refresh the page or switch tabs to reload data

## Future Enhancements

- [ ] Bulk import from CSV
- [ ] Export master data to CSV
- [ ] Department hierarchy (parent/child relationships)
- [ ] Category icons/colors
- [ ] Location map integration
- [ ] Audit log for master data changes
- [ ] Search and filter within each tab
- [ ] Pagination for large datasets
- [ ] Department cost centers
- [ ] Location capacity tracking

## File Location
`/frontend/pages/master-data.tsx`

## Dependencies
- React
- Next.js
- Supabase
- Lucide React Icons
- Tailwind CSS

## Related Pages
- Assets (`/assets`)
- Import Assets (`/asset-import`)
- Settings (`/settings`)
