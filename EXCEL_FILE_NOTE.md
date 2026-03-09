# Excel File Not Included

The `ConnUCMatrix.xlsx` file is not included in this repository as it contains project-specific data.

## To use this application:

1. Create or obtain your Excel file with the following structure:
   - **Row 1-2**: Main category headers (can have merged cells)
   - **Row 3**: Column headers
   - **Row 4+**: Data rows

2. Name the file `ConnUCMatrix.xlsx`

3. Place it in the root directory of this project (same folder as `app.py`)

## Example Structure:

```
Row 1: [General Information spanning cols A-J] [Import/Recon spanning cols K-Z] ...
Row 2: [covered by row 1 merge]                [User Import] [Account Import] ...
Row 3: [Connector] [OOTB] [Owner] ...          [Full] [Incremental] ...
Row 4: [Data]      [Data] [Data]  ...          [Y]    [N]           ...
```

The application will automatically:
- Detect and preserve merged cells in headers
- Identify Y/N columns and provide dropdowns
- Allow editing of all data rows
