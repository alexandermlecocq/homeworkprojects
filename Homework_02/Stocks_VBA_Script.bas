Attribute VB_Name = "Module1"
Sub Button1_Click()

Dim RowNum As Long
Dim StockVolume As Double
Dim CompanyNum As Long
Dim CompanyTicker As String
Dim FirstDayValue As Double
Dim LastDayValue As Double
Dim PercentIncreaseValue As Double
Dim PercentIncreaseTicker As String
Dim PercentDecreaseValue As Double
Dim PercentDecreaseTicker As String
Dim TotalVolumeValue As Double
Dim TotalVolumeTicker As String
Dim WorksheetName(3) As String



WorksheetName(0) = "2014"
WorksheetName(1) = "2015"
WorksheetName(2) = "2016"

For n = 0 To 2                                                                                              'Cycles through the worksheets

    CompanyNum = 1                                                                                          'Resets each sheet's major variables so they don't interfere with one another
    RowNum = 2
    PercentIncreaseValue = 0
    PercentIncreaseTicker = ""
    PercentDecreaseValue = 0
    PercentDecreaseTicker = ""
    TotalVolumeValue = 0
    TotalVolumeTicker = ""

    Do While Worksheets(WorksheetName(n)).Cells(RowNum, 1) <> ""                                            'Check for end of the worksheet's dataset, otherwise continue with current company
    
        CompanyTicker = Worksheets(WorksheetName(n)).Cells(RowNum, 1)                                       'Set the Ticker name as the current company
        StockVolume = Worksheets(WorksheetName(n)).Cells(RowNum, 7)                                         'Reset the stock volume to that of the company's first day
        FirstDayValue = Worksheets(WorksheetName(n)).Cells(RowNum, 3)                                       'Save the Opening value of the company's first day
        RowNum = RowNum + 1                                                                                 'Advance to second day so that the while loop works
        
        'MsgBox (CompanyTicker)
        'MsgBox (StockVolume)
        
        
        Do While Worksheets(WorksheetName(n)).Cells(RowNum, 1).Value = Worksheets(WorksheetName(n)).Cells(RowNum - 1, 1)   'Sum all the remaining stock volumes for the company between the second day and the last day
            StockVolume = StockVolume + Worksheets(WorksheetName(n)).Cells(RowNum, 7)
            RowNum = RowNum + 1
        Loop                                                                        'Note: the loop ends on the line AFTER the current company's last day (i.e. the next company's first day)
        LastDayValue = Worksheets(WorksheetName(n)).Cells(RowNum - 1, 6)            'Save the closing value of the current company's last day
                                        
        
        CompanyNum = CompanyNum + 1                                                 'Increment company output line to not overwrite previous line
        Worksheets(WorksheetName(n)).Cells(CompanyNum, 9) = CompanyTicker           'Outputs the company's data to the spreadsheet
        If FirstDayValue = 0 Then                                                   'Avoids dealing with the pesky 0 errors for companies that started trading later in the year
            Worksheets(WorksheetName(n)).Cells(CompanyNum, 10) = "First Year Trading"
            Worksheets(WorksheetName(n)).Cells(CompanyNum, 11) = "First Year Trading"
        Else
            Worksheets(WorksheetName(n)).Cells(CompanyNum, 10) = LastDayValue - FirstDayValue
            Worksheets(WorksheetName(n)).Cells(CompanyNum, 11) = (LastDayValue - FirstDayValue) / FirstDayValue
            
            If (LastDayValue - FirstDayValue) / FirstDayValue > PercentIncreaseValue Then       'Check if higher/lower than current highest/lowest percentage change
                PercentIncreaseValue = (LastDayValue - FirstDayValue) / FirstDayValue           'If so, make this company the new highest/lowest
                PercentIncreaseTicker = CompanyTicker
            ElseIf (LastDayValue - FirstDayValue) / FirstDayValue < PercentDecreaseValue Then
                PercentDecreaseValue = (LastDayValue - FirstDayValue) / FirstDayValue
                PercentDecreaseTicker = CompanyTicker
            End If
        End If
        Worksheets(WorksheetName(n)).Cells(CompanyNum, 12) = StockVolume
        If StockVolume > TotalVolumeValue Then                                                  'Check if stock volume higher than current highest volume
            TotalVolumeValue = StockVolume                                                      'If so, make this company the new highest
            TotalVolumeTicker = CompanyTicker
        End If
        
        
    Loop                                                                                        'Once all companies on a worksheet have been processed, output superlatives
    
    Worksheets(WorksheetName(n)).Cells(2, 15) = PercentIncreaseTicker
    Worksheets(WorksheetName(n)).Cells(2, 16) = PercentIncreaseValue
    Worksheets(WorksheetName(n)).Cells(3, 15) = PercentDecreaseTicker
    Worksheets(WorksheetName(n)).Cells(3, 16) = PercentDecreaseValue
    Worksheets(WorksheetName(n)).Cells(4, 15) = TotalVolumeTicker
    Worksheets(WorksheetName(n)).Cells(4, 16) = TotalVolumeValue
    
Next n                                                                                          'Move to next worksheet
    
End Sub
