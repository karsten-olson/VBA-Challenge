Attribute VB_Name = "Module1"
Sub vbamacro()

'creat variables

    Dim Ticker As String
    Dim datarow As Integer
    Dim Workbook As Workbook
    Dim yearchange As Double
    Dim percentchange As Double
    Dim openprice As Double
    Dim closeprice As Double
    Dim stockvol As Double

'set set them to 0

    stockvol = 0
    yearchange = 0
    percentchange = 0
    openprice = 0
    closeprice = 0
    
'looping through all the worksheets

Set Workbook = ActiveWorkbook
For Each ws In Workbook.Worksheets
ws.Activate

    'Start looping at second row ignoring header row
    datarow = 2
    'Find last row in current sheet
    LastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    'Loop through each row in the current sheet
    For i = 2 To LastRow

        'If the ticker value not the same as previous ticker, then:

        'Have the first value in Open col for each ticker be openprice variable:
        If ws.Cells(i - 1, 1).Value <> ws.Cells(i, 1).Value Then
            openprice = Cells(i, 3).Value
            Ticker = ws.Cells(i, 1).Value
            
        'If next cell's ticker is the same then do following:
        ElseIf ws.Cells(i + 1, 1).Value = ws.Cells(i, 1).Value Then
            'Adding stock volumes:
            stockvol = stockvol + Cells(i, 7).Value
        'Finding year-end stock price:
        ElseIf ws.Cells(i, 1).Value <> ws.Cells(i + 1, 1).Value Then
            closeprice = Cells(i, 6).Value
            'find total year change for each ticker
            yearchange = closeprice - openprice
            'Find percentage change from year
                If closeprice <> openprice Then
                    percentchange = (openprice - closeprice) / closeprice * -1
                End If
            'Continuously add the vol from volume col while same Ticker
            stockvol = stockvol + ws.Cells(i, 7).Value
            'In col I, put the Ticker string in summary table
            ws.Range("I" & datarow).Value = Ticker
            'In col J, input year change amount (closeprice-openprice)
            ws.Range("J" & datarow).Value = yearchange
            'In col K, input percentchance from each ticker
            ws.Range("K" & datarow).Value = percentchange
            'In col L, input total stockvol sum
            ws.Range("L" & datarow).Value = stockvol
            'Change color format to green if the change is positive
                If ws.Range("J" & datarow).Value >= 0 Then
                ws.Range("J" & datarow).Interior.ColorIndex = 4
            'Chance color to red if negative change
                Else
                ws.Range("J" & datarow).Interior.ColorIndex = 3
                End If
            'add to datarow counter
            datarow = datarow + 1
            'reset values below for next ticker
            openprice = 0
            closeprice = 0
            yearchange = 0
            percentchange = 0
            stockvol = 0
            
         End If
        
    Next i
    'Adding header names in summary table
    ws.Cells(1, 9).Value = "Ticker"
    ws.Cells(1, 10).Value = "Yearly Change"
    ws.Cells(1, 11).Value = "Percent Change"
    ws.Cells(1, 12).Value = "Total Volume"
    'Formatting values in summary table
    ws.Range("J:J").Style = "Currency"
    ws.Range("K:K").NumberFormat = "0.00%"
    ws.Columns("I:L").AutoFit
    
 Next ws

End Sub
