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

For n = 0 To 2                                                                                                              'Cycles through the worksheets

    CompanyNum = 1                                                                                                          'Resets each worksheet's major variables so they don't interfere with one another
    RowNum = 2
    PercentIncreaseValue = 0
    PercentIncreaseTicker = ""
    PercentDecreaseValue = 0
    PercentDecreaseTicker = ""
    TotalVolumeValue = 0
    TotalVolumeTicker = ""

    Do While Worksheets(WorksheetName(n)).Cells(RowNum, 1) <> ""                                                            'Check for end of the worksheet's dataset, otherwise begin processing the company on this row
    
        CompanyTicker = Worksheets(WorksheetName(n)).Cells(RowNum, 1)                                                       'Set the Ticker name as the current company
        StockVolume = Worksheets(WorksheetName(n)).Cells(RowNum, 7)                                                         'Reset the stock volume to that of the company's first day
        FirstDayValue = Worksheets(WorksheetName(n)).Cells(RowNum, 3)                                                       'Save the opening value of the company's first day
        RowNum = RowNum + 1                                                                                                 'Advance to second day so that the while loop works
        
        Do While Worksheets(WorksheetName(n)).Cells(RowNum, 1).Value = Worksheets(WorksheetName(n)).Cells(RowNum - 1, 1)    'Sum all the remaining stock volumes for the company between the second day and the last day
            StockVolume = StockVolume + Worksheets(WorksheetName(n)).Cells(RowNum, 7)
            If FirstDayValue = 0 And Worksheets(WorksheetName(n)).Cells(RowNum, 3) <> 0 Then                                'If the company didnt start trading until the middle of the year, this statement hopefully grabs the first non-zero value of the year
                FirstDayValue = Worksheets(WorksheetName(n)).Cells(RowNum, 3)
            End If
            RowNum = RowNum + 1
        Loop                                                                                                                'Note: the loop ends on the line AFTER the current company's last day (i.e. the next company's first day)
        LastDayValue = Worksheets(WorksheetName(n)).Cells(RowNum - 1, 6)                                                    'Save the closing value of the current company's last day (which is on the previous line)
                                               
        CompanyNum = CompanyNum + 1                                                                                         'Increment company output line to not overwrite previous line
        Worksheets(WorksheetName(n)).Cells(CompanyNum, 9) = CompanyTicker                                                   'Outputs the company's ticker to the spreadsheet
        Worksheets(WorksheetName(n)).Cells(CompanyNum, 10) = LastDayValue - FirstDayValue                                   'Outputs the company's change in stock value

        If FirstDayValue <> 0 Then                                                                                          'If the company never traded at all this year, this if statment prevents a divide by zero error
            Worksheets(WorksheetName(n)).Cells(CompanyNum, 11) = (LastDayValue - FirstDayValue) / FirstDayValue             'Output the % change
            If (LastDayValue - FirstDayValue) / FirstDayValue > PercentIncreaseValue Then                                   'Check if higher/lower than current highest/lowest percentage change
                PercentIncreaseValue = (LastDayValue - FirstDayValue) / FirstDayValue                                       'If higher, make this company the new highest
                PercentIncreaseTicker = CompanyTicker
            ElseIf (LastDayValue - FirstDayValue) / FirstDayValue < PercentDecreaseValue Then
                PercentDecreaseValue = (LastDayValue - FirstDayValue) / FirstDayValue                                       'If lowest, make this company the new lowest
                PercentDecreaseTicker = CompanyTicker
            End If
        Else
            Worksheets(WorksheetName(n)).Cells(CompanyNum, 11) = 0                                                          'If the company stock value remained zero for the whole year, just return 0
        End If
        
        Worksheets(WorksheetName(n)).Cells(CompanyNum, 12) = StockVolume
        If StockVolume > TotalVolumeValue Then                                                                              'Check if the company's stock volume higher than current highest volume
            TotalVolumeValue = StockVolume                                                                                  'If so, make this company the new highest
            TotalVolumeTicker = CompanyTicker
        End If
        
    Loop                                                                                                                    'Begin again with the next company
    
    Worksheets(WorksheetName(n)).Cells(2, 15) = PercentIncreaseTicker                                                       'Once all companies on a worksheet have been processed, output superlatives
    Worksheets(WorksheetName(n)).Cells(2, 16) = PercentIncreaseValue
    Worksheets(WorksheetName(n)).Cells(3, 15) = PercentDecreaseTicker
    Worksheets(WorksheetName(n)).Cells(3, 16) = PercentDecreaseValue
    Worksheets(WorksheetName(n)).Cells(4, 15) = TotalVolumeTicker
    Worksheets(WorksheetName(n)).Cells(4, 16) = TotalVolumeValue
    
Next n                                                                                                                      'Move to next worksheet
    
MsgBox ("Done!")

End Sub