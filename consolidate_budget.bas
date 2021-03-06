Attribute VB_Name = "Module1"
Public Sub Consolidate_Budget()
Dim con_budget As Worksheet
Set con_budget = ThisWorkbook.Sheets("Consolidated Data")

'lastrow for clearing previous contents
lr = con_budget.UsedRange.Rows(ActiveSheet.UsedRange.Rows.Count).Row
If lr <> 4 Then
con_budget.Range("a5:dp" & lr).ClearContents
End If

    Dim wbk As Workbook
    Dim myPath As String
    Dim myFile As String
    Dim FolderName As String
     
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    Application.Calculation = xlCalculationManual
          
    'dialog box for selecting folder containing files
    With Application.FileDialog(msoFileDialogFolderPicker)
        .AllowMultiSelect = False
        .Show
        On Error Resume Next
        FolderName = .SelectedItems(1)
        Err.Clear
        On Error GoTo 0
    End With
     
    myPath = FolderName
     
    If Right(myPath, 1) <> "\" Then myPath = myPath & "\"
     
    myFile = Dir(myPath & "*.xls*")
    Lastrow = ActiveSheet.UsedRange.Rows(ActiveSheet.UsedRange.Rows.Count).Row
    f = Lastrow + 1
    r = Lastrow + 1
    'length is the number of rows copied fro each file
    lenth = 315
    
    'loop through all files in the folder
    Do While Len(myFile) > 0
Set wbk = Workbooks.Open(myPath & myFile)
    'copying columns and pasting in new file
    wbk.Sheets("FTE").Range("A13:B328,D13:M328").Copy
    Windows("consolidated_budget.xlsb").Activate
    con_budget.Cells(r, 3).PasteSpecial Paste:=xlPasteValues
    con_budget.Range(Cells(r, 1), Cells(r + lenth, 1)) = wbk.Sheets("FTE").Range("B2")
    
    wbk.Sheets("Billing Rates").Range("G13:G328,J13:M328,P13:T328").Copy
    Windows("consolidated_budget.xlsb").Activate
    con_budget.Cells(r, 15).PasteSpecial Paste:=xlPasteValues
    
    wbk.Sheets("FTE").Range("AGD13:AGO328").Copy
    Windows("consolidated_budget.xlsb").Activate
    con_budget.Cells(r, 25).PasteSpecial Paste:=xlPasteValues
    
    wbk.Sheets("FTE").Range("AHB13:AHC328,AHG13:AHR328,AHW13:AHW328,AIN13:AIP328").Copy
    Windows("consolidated_budget.xlsb").Activate
    con_budget.Cells(r, 43).PasteSpecial Paste:=xlPasteValues
    
    wbk.Sheets("FTE").Range("AGP13:AHA328").Copy
    Windows("consolidated_budget.xlsb").Activate
    con_budget.Cells(r, 158).PasteSpecial Paste:=xlPasteValues
    
    wbk.Sheets("COLA Working").Range("CQ13:DB328,DG13:DG328,DX13:DZ328").Copy
    Windows("consolidated_budget.xlsb").Activate
    con_budget.Cells(r, 62).PasteSpecial Paste:=xlPasteValues
    
    wbk.Sheets("Output ").Range("K14:AA329,AR14:AT329").Copy
    Windows("consolidated_budget.xlsb").Activate
    con_budget.Cells(r, 79).PasteSpecial Paste:=xlPasteValues
    
    r = r + lenth + 1
    
    f = r
    
    
    Application.CutCopyMode = False
    wbk.Close True
    myFile = Dir
Loop

'columns which have autofill formulas
con_budget.Range(Cells(5, 37), Cells(r, 37)).Formula = "=AVERAGE(Y5:AA5)"
con_budget.Range(Cells(5, 38), Cells(r, 38)).Formula = "=AVERAGE(AB5:AD5)"
con_budget.Range(Cells(5, 39), Cells(r, 39)).Formula = "=AVERAGE(AE5:AG5)"
con_budget.Range(Cells(5, 40), Cells(r, 40)).Formula = "=AVERAGE(AH5:AJ5)"
con_budget.Range(Cells(5, 41), Cells(r, 41)).Formula = "=AVERAGE(Y5:AJ5)"
con_budget.Range(Cells(5, 42), Cells(r, 42)).Formula = "=FN5"

con_budget.Range(Cells(5, 100), Cells(r, 119)).Formula = "=CA5/$J5"
con_budget.Range(Cells(5, 170), Cells(r, 170)).Formula = "=SUM(FB5:FM5)"

'delete empty rows or which do not satify the condition
Sheets("Consolidated Data").Select
Range("A4").Select
Selection.AutoFilter
Sheets("Consolidated Data").Range(Cells(4, 1), Cells(r, 119)).AutoFilter Field:=3, Criteria1:=Array( _
        "0", "Process Names", "Process Name", "Transaction Based Pricing", "="), Operator:=xlFilterValues
Range(Cells(5, 10), Cells(r, 10)).SpecialCells(xlCellTypeVisible).EntireRow.Delete
Range("A4").Select
Selection.AutoFilter


Range("A4").Select

Application.ScreenUpdating = True
Application.DisplayAlerts = True
Application.Calculation = xlCalculationAutomatic

End Sub

