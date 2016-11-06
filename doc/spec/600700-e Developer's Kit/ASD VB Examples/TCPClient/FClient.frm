VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{65E121D4-0C60-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCHRT20.OCX"
Begin VB.Form FClient 
   Caption         =   "TCPClient"
   ClientHeight    =   8040
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   11250
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8040
   ScaleWidth      =   11250
   StartUpPosition =   2  'CenterScreen
   Begin MSChart20Lib.MSChart MSChart1 
      Height          =   5835
      Left            =   180
      OleObjectBlob   =   "FClient.frx":0000
      TabIndex        =   12
      Top             =   180
      Width           =   10815
   End
   Begin VB.ListBox List1 
      Height          =   1425
      Left            =   5100
      TabIndex        =   11
      Top             =   6240
      Width           =   4395
   End
   Begin VB.CommandButton Command1 
      Height          =   315
      Left            =   2580
      TabIndex        =   10
      TabStop         =   0   'False
      Top             =   7440
      Width           =   2355
   End
   Begin VB.CommandButton cmdReflectance 
      Caption         =   "Reflectance"
      Height          =   315
      Left            =   2580
      TabIndex        =   9
      Top             =   7140
      Width           =   2355
   End
   Begin VB.CommandButton cmdDarkCurrent 
      Caption         =   "Dark Corrected Spectrum"
      Height          =   315
      Left            =   2580
      TabIndex        =   8
      Top             =   6840
      Width           =   2355
   End
   Begin VB.CommandButton cmdAcquire 
      Caption         =   "Acquire"
      Height          =   315
      Left            =   2580
      TabIndex        =   7
      Top             =   6540
      Width           =   2355
   End
   Begin VB.CommandButton cmdOptimize 
      Caption         =   "Optimize"
      Height          =   315
      Left            =   2580
      TabIndex        =   6
      Top             =   6240
      Width           =   2355
   End
   Begin VB.CommandButton cmdEndWavelength 
      Caption         =   "Get Ending Wavelength"
      Height          =   315
      Left            =   240
      TabIndex        =   5
      Top             =   7440
      Width           =   2355
   End
   Begin VB.CommandButton cmdStartWavelength 
      Caption         =   "Get Starting Wavelength"
      Height          =   315
      Left            =   240
      TabIndex        =   4
      Top             =   7140
      Width           =   2355
   End
   Begin VB.CommandButton cmdVersion 
      Caption         =   "Version"
      Height          =   315
      Left            =   240
      TabIndex        =   3
      Top             =   6840
      Width           =   2355
   End
   Begin VB.CommandButton cmdDisconnect 
      Caption         =   "Disconnect"
      Height          =   315
      Left            =   240
      TabIndex        =   2
      Top             =   6540
      Width           =   2355
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "Connect"
      Height          =   315
      Left            =   240
      TabIndex        =   1
      Top             =   6240
      Width           =   2355
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   435
      Left            =   9780
      TabIndex        =   0
      Top             =   7260
      Width           =   1095
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   10500
      Top             =   6480
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
End
Attribute VB_Name = "FClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const DEFAULT_TIME_OUT As Long = 4000            ' Default Time Out in ms
Private Const DEFAULT_OPTIMIZE_TIME_OUT As Long = 40000  ' Default Optimization Timeout in ms

Private Const H_NO_ERROR As Long = 100
Private Const H_COLLECT_ERROR As Long = 200
Private Const H_COLLECT_NOT_LOADED As Long = 300
Private Const H_INIT_ERROR As Long = 400
Private Const H_FLASH_ERROR As Long = 500
Private Const H_RESET_ERROR As Long = 600
Private Const H_INTERPOLATE_ERROR As Long = 700
Private Const H_OPTIMIZE_ERROR As Long = 800
Private Const H_INSTRUMENT_CONTROL_ERROR As Long = 900
'
' Return error codes.
'
Private Const NO_ERROR As Long = 0
Private Const NOT_READY As Long = -1
Private Const NO_INDEX_MARKS As Long = -2
Private Const TOO_MANY_ZEROS As Long = -3
Private Const SCANSIZE_ERROR As Long = -4
' -5 unused
Private Const COMMAND_ERROR As Long = -6
Private Const INI_FULL As Long = -7
Private Const MISSING_PARAMETER As Long = -8
' -9 unused - now -20, -21, -22
Private Const VNIR_TIMEOUT As Long = -10
Private Const SWIR_TIMEOUT As Long = -11
Private Const VNIR_NOT_READY As Long = -12
Private Const SWIR1_NOT_READY As Long = -13
Private Const SWIR2_NOT_READY As Long = -14
Private Const VNIR_OPT_ERROR As Long = -15
Private Const SWIR1_OPT_ERROR As Long = -16
Private Const SWIR2_OPT_ERROR As Long = -17
Private Const ABORT_ERROR As Long = -18
Private Const PARAM_ERROR As Long = -19
Private Const VNIR_INTERP_ERROR As Long = -20
Private Const SWIR1_INTERP_ERROR As Long = -21
Private Const SWIR2_INTERP_ERROR As Long = -22

Private Enum NET_IO_INTERFACE
   NET_IO_SUCCESS = 0                'Net IO Success
   NET_IO_TIMEOUT                    'Net IO Timeout Error
   NET_IO_ABORT                      'Net IO Abort
   NET_CONNECTION_SUCCESS            'Net Connection Success
   NET_CONNECTION_FAILED             'Net Failed Connection
   NET_CONNECTION_ERROR              'Net Error in Connection
   NET_NO_DATA                       'NO Data
End Enum

Private Type BigEndianDouble            'Big to Little Endian conversion for Double Type
    MSDWord As Long                     'Most significant DWord
    LSDWord As Long                     'Least significant DWord
End Type
'
' Vnir Header section
'
Private Type Vnir_Header
    IT As Long
    scans As Long
    max_channel As Long
    min_channel As Long
    saturation As Long
    shutter As Long
    drift As Long
    dark_subtracted As Long
    Reserved(7) As Long
End Type
'
' Swir Header section
'
Private Type Swir_Header
   tec_status As Long
   tec_current As Long
   max_channel As Long
   min_channel As Long
   saturation As Long
   A_Scans As Long
   B_Scans As Long
   dark_current As Long
   gain As Long
   offset As Long
   scansize_1 As Long
   scansize_2 As Long
   dark_subtracted As Long
   Reserved(2) As Long
End Type
'
' return Spectrum Header - Len(64)
'
Private Type SpectrumHeader
   Header As Long
   errbyte As Long
   sample_count As Long
   Trigger As Long
   voltage As Long
   current As Long
   temperature As Long
   motor_current As Long
   instrument_hours As Long
   instrument_minutes As Long
   instrument_type As Long
   AB As Long
   Reserved(3) As Long
   v_Header As Vnir_Header
   s1_header As Swir_Header
   s2_header As Swir_Header
End Type
'
' Acquire - Interpolated Spectrum Struct
'
Private Type FRInterpSpecStruct
   FR_Header As SpectrumHeader
   SpecBuffer(2150) As Single
End Type
'
' ParamStruct
'
Private Type ParamStruct
   Header As Long
   errbyte As Long
   Name As String
   value As Double
   Count As Long
End Type
'
' Optimization Struct
'
Private Type OptimizeStruct
   Header As Long             'header type used in TCP transfer.
   errbyte As Long            'error code
   itime As Long              'optimized integration time
   gain(1) As Long            'optimized gain for 2 SWIRs
   offset(1) As Long          'optimized offset for 2 SWIRs
End Type
'
' Instrument Control Struct
'
Private Type InstrumentControlStruct
   Header As Long            'header type used in TCP transfer
   errbyte As Long           'error code
   detector As Long
   cmdType As Long
   value As Long
End Type
'
' Header Struct
'
Private Type HeaderStruct
   Header As Long
   errbyte As Long
End Type

Private Declare Function GetTickCount Lib "kernel32" () As Long
Private Declare Function NetToHostLong Lib "ws2_32.dll" Alias "ntohl" (ByVal l32BitBigEndian As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (param1 As Any, param2 As Any, ByVal Length As Long)

Private mlNetBytesToRead As Long
Private msNetData As String
Private mlNetBytesRead As Long
Private mbConnected As Boolean
Private mayNetByteBuffer() As Byte
Private mlVnirStartingWavelength As Long
Private mlVnirEndingWavelength As Long
Private mlVnirDarkCurrentCorrection As Long

Private Sub cmdAcquire_Click()

   Dim iss As FRInterpSpecStruct
   Dim lReturn As Long
   
   InitGraph
   
   ' Clear the list box
   List1.Clear
   List1.AddItem "Collecting..."
   InitGraph
   
   lReturn = Acquire("A,1,10", Len(iss), DEFAULT_TIME_OUT, iss)

   Select Case lReturn
      Case NET_IO_SUCCESS

         ' Add to ListBox
         With List1
            .Clear
            .AddItem "Header - " & iss.FR_Header.Header
            .AddItem "Errbyte - " & iss.FR_Header.errbyte
         End With
         
         If iss.FR_Header.Header = H_NO_ERROR Then
            PlotGraph iss.SpecBuffer
         End If
         

      Case Else
         '
   End Select
   
End Sub

Private Function Acquire(ByVal sCommand As String, _
                         ByVal packetSize As Long, _
                         ByVal timeout As Double, _
                         iss As FRInterpSpecStruct) As Long
                    
                    
   Dim lReturn As Long
   Dim asngNet() As Single
   
   ' Clear buffers
   ClearNetBuffer
   
   ' Send the Command
   Winsock1.SendData sCommand
   
   ' Wait for Response
   lReturn = WaitForNetIOEvent(packetSize, timeout)
                   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Copy the String buffer to a byte buffer
         ReDim mayNetByteBuffer(packetSize) As Byte
         CopyMemory mayNetByteBuffer(0), ByVal msNetData, packetSize
                
         ReDim alHeader((Len(iss.FR_Header) / 4) - 1) As Long
         ReDim ayHeader(Len(iss.FR_Header) - 1) As Byte
         CopyMemory ayHeader(0), mayNetByteBuffer(0), Len(iss.FR_Header)
         ConvertNetToHostLong ayHeader, alHeader
                
         ' Put in the FRInterpStruct
         CopyMemory iss.FR_Header, alHeader(0), Len(iss.FR_Header)
         ' Convert to Single Buffer
         ConvertNetToHostSingle mayNetByteBuffer, asngNet
         ' Copy the Data back into the FRInterpSpecStruct
         CopyMemory iss.SpecBuffer(0), asngNet(Len(iss.FR_Header) / 4), (UBound(iss.SpecBuffer) + 1) * 4
         Acquire = lReturn
         
      Case NET_IO_TIMEOUT
         MsgBox "Unable to Acquire.", vbOKOnly + vbExclamation, Me.Caption
         Acquire = lReturn
         
      Case NET_IO_ABORT
         Acquire = lReturn
         
   End Select

End Function

Private Function Optimize(ByVal sCommand As String, _
                          ByVal packetSize As Long, _
                          ByVal timeout As Double, _
                          os As OptimizeStruct) As Long
                    
                    
   Dim lReturn As Long
   Dim alHost() As Long
   
   ' Clear buffers
   ClearNetBuffer
   
   ' Send the Command
   Winsock1.SendData sCommand
   
   ' Wait for Response
   lReturn = WaitForNetIOEvent(packetSize, timeout)
                   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Copy the String buffer to a byte buffer
         ReDim mayNetByteBuffer(packetSize) As Byte
         CopyMemory mayNetByteBuffer(0), ByVal msNetData, packetSize
         
         ' Convert to LittleEndian
         ConvertNetToHostLong mayNetByteBuffer, alHost
         
         ' Put in the OptimizeStruct
         os.Header = alHost(0)
         os.errbyte = alHost(1)
         os.itime = alHost(2)
         os.gain(0) = alHost(3)
         os.gain(1) = alHost(4)
         os.offset(0) = alHost(5)
         os.offset(1) = alHost(6)
         
         Optimize = lReturn
         
      Case NET_IO_TIMEOUT
         MsgBox "Unable to Optimize.", vbOKOnly + vbExclamation, Me.Caption
         Optimize = lReturn
         
      Case NET_IO_ABORT
         Optimize = lReturn
         
   End Select

End Function

Private Function ConvertNetToHostSingle(ayNet() As Byte, asngHost() As Single) As Boolean
                  
   Dim nByte As Integer
   Dim nHostByte As Integer
   Dim lNet As Long
   Dim lHost As Long
   Dim sngValue As Single
      
   'Allocate memory for Array
   ReDim asngHost(UBound(ayNet) \ 4) As Single
   
   For nByte = 0 To UBound(ayNet) Step 4
      ' Copy 4 bytes to a Long
      CopyMemory lNet, ayNet(nByte), Len(lNet)
      ' Convert to LittleEndian
      lHost = NetToHostLong(lNet)
      ' Copy the Long to a Single
      CopyMemory sngValue, lHost, Len(sngValue)
      ' Store in the Array
      asngHost(nHostByte) = sngValue
      'Debug.Print lNet; lHost; sngValue
      nHostByte = nHostByte + 1
   Next
   
   ConvertNetToHostSingle = True
   
End Function

Private Sub cmdClose_Click()
   If mbConnected = True Then
      TerminateConnection
   End If
   
   Unload Me
End Sub

Private Sub cmdConnect_Click()

   Const INIT_CONNECTION_BYTES_TO_READ As Long = 32                 ' Init Bytes to Read
   Const INIT_CONNECTION_TIMEOUT As Long = 20000

   Dim lStart As Long
   Dim ps As ParamStruct
   Dim lReturn As Long
   
   With Winsock1
      ' Close an existing connection
      TerminateConnection
      ' Connect to TCPServer
      ' Port for the TCP Server is 8080
      .RemotePort = 8080
      ' Set to TCP Protocol
      .Protocol = sckTCPProtocol
      ' Change the IP Address from 169.254.1.11 to the set IP Address
      ' if different
      .RemoteHost = "169.254.1.11"
      
      ' Clear List Box
      List1.Clear
      ' Update List Box with Connecting message.
      List1.AddItem "Connecting..."
      ' Clear Buffers
      ClearNetBuffer
      ' Try to Connect
      .Connect
      
      lStart = GetTickCount

      Do
         Select Case .State
            Case sckConnecting, sckConnectionPending, sckOpen
               'Debug.Print "Waiting - " & .State
               
               DoEvents
               ' Time out
               If (GetTickCount() - lStart) > INIT_CONNECTION_TIMEOUT Then
                  List1.AddItem "Unable to Connect."
                  MsgBox "Unable to Connect", vbOKOnly + vbExclamation, Me.Caption
                  Exit Do
               End If
               
            Case sckError
               ' Problem with the socket
               List1.AddItem "Unable to Connect."
               MsgBox "Unable to Connect", vbOKOnly + vbExclamation, Me.Caption
               Exit Do
            Case sckConnected
               mbConnected = True
               DoEvents
               
               Select Case WaitForNetIOEvent(INIT_CONNECTION_BYTES_TO_READ, DEFAULT_TIME_OUT)
                  Case NET_IO_SUCCESS
                     MsgBox msNetData
                  Case NET_IO_ABORT, NET_IO_TIMEOUT
                     List1.AddItem "Unable to Connect."
                     MsgBox "Unable to Connect", vbOKOnly + vbExclamation, Me.Caption
               End Select
               
               Exit Do
         End Select
      Loop
   End With
   
   If mbConnected Then
      ' Restore the Flash if 1.5 or greater
      '
      lReturn = GetFlashValue("V", 50, DEFAULT_TIME_OUT, ps)
   
      Select Case lReturn
         Case NET_IO_SUCCESS
            ' Check Version
            If ps.value >= 1.5 Then
               ' Restore Flash - required for 1.5 version or greater to build
               ' calibration Arrays
               lReturn = RestoreFlash("RESTORE,1", 7616, 20000)
               ' Convert first 4 bytes for Header return
               
               ' convert next 4 bytes for errbyte return
               Select Case lReturn
                  Case NET_IO_SUCCESS
                     ' Enable the Buttons
                     cmdConnect.Enabled = False
                     cmdDisconnect.Enabled = True
                     cmdVersion.Enabled = True
                     cmdStartWavelength.Enabled = True
                     cmdEndWavelength.Enabled = True
                     cmdOptimize.Enabled = True
                     cmdAcquire.Enabled = True
                     cmdDarkCurrent.Enabled = True
                     cmdReflectance.Enabled = True
                  Case Else
                    
   
               End Select
               List1.Clear
            Else
                ' Enable the Buttons
               cmdConnect.Enabled = False
               cmdDisconnect.Enabled = True
               cmdVersion.Enabled = True
               cmdStartWavelength.Enabled = True
               cmdEndWavelength.Enabled = True
               cmdOptimize.Enabled = True
               cmdAcquire.Enabled = True
               cmdDarkCurrent.Enabled = True
               cmdReflectance.Enabled = True
               List1.Clear
            End If
            
         Case Else
            With List1
               .Clear
               .AddItem "Header - " & ps.Header
               .AddItem "Errbyte - " & ps.errbyte
               .AddItem "Name - " & ps.Name
               .AddItem "Value - " & ps.value
               .AddItem "Type - " & ps.Count
            End With
            Exit Sub
      End Select
      
   End If

End Sub

Private Function WaitForNetIOEvent(lbytesRead As Long, dTimeOut As Double) As NET_IO_INTERFACE

   Const PROC_NAME As String = "WaitForNetIOEvent"
       
   Dim lStart As Long
   
   On Error Resume Next
   
   lStart = GetTickCount
            
   Do
      If (mlNetBytesRead >= lbytesRead) Then
         
         WaitForNetIOEvent = NET_IO_SUCCESS
         Exit Do
     
      ElseIf ((GetTickCount() - lStart) > dTimeOut) Then
         If Winsock1.State = sckError Then
            WaitForNetIOEvent = NET_CONNECTION_ERROR
         Else
            WaitForNetIOEvent = NET_IO_TIMEOUT
         End If
         Exit Do
      Else
         DoEvents
      End If
   Loop
   
   
End Function

Private Sub ClearNetBuffer()
   
   msNetData = ""
   mlNetBytesToRead = 0
   mlNetBytesRead = 0
  
End Sub

Private Sub TerminateConnection()
   With Winsock1
      If .State <> sckClosed Then
         .Close
      End If
   End With
End Sub

Private Sub cmdDarkCurrent_Click()
   
   Dim ps As ParamStruct
   Dim os As OptimizeStruct
   Dim iss As FRInterpSpecStruct
   Dim issDarkSpectrum As FRInterpSpecStruct
   Dim ic As InstrumentControlStruct
   Dim dark_drift As Long
   Dim current_drift As Long
   Dim drift As Single
   Dim lReturn As Long
   Dim i As Integer
   
   InitGraph
   
   If mlVnirStartingWavelength = 0 Then
      ' Clear the list box
      List1.Clear
      List1.AddItem "Getting Vnir Starting Wavelength..."
      lReturn = GetFlashValue("INIT,0,VStartingWavelength", 50, DEFAULT_TIME_OUT, ps)
      
      Select Case lReturn
         Case NET_IO_SUCCESS
            ' Add to ListBox
            mlVnirStartingWavelength = ps.value
         Case Else
            '
      End Select
      
      ' Clear the list box
      List1.Clear
      List1.AddItem "Getting Vnir Ending Wavelength..."
      
      lReturn = GetFlashValue("INIT,0,VEndingWavelength", 50, DEFAULT_TIME_OUT, ps)
      
      Select Case lReturn
         Case NET_IO_SUCCESS
            ' Add to ListBox
            mlVnirEndingWavelength = ps.value
         Case Else
            '
      End Select
      
      ' Clear the list box
      List1.Clear
      List1.AddItem "Getting Vnir DarkCurrentCorrection..."
      
      lReturn = GetFlashValue("INIT,0,VDarkCurrentCorrection", 50, DEFAULT_TIME_OUT, ps)
      
      Select Case lReturn
         Case NET_IO_SUCCESS
            ' Add to ListBox
            mlVnirDarkCurrentCorrection = ps.value
         Case Else
            '
      End Select
   End If
   
   ' Clear the list box
   List1.Clear
   List1.AddItem "Optimizing..."
   InitGraph
   ' Optimize the Instrument
   lReturn = Optimize("OPT,7", Len(os), DEFAULT_OPTIMIZE_TIME_OUT, os)

   ' Add to ListBox
   With List1
      .Clear
      .AddItem "Header - " & os.Header
      .AddItem "Errbyte - " & os.errbyte
      .AddItem "itime - " & os.itime
      .AddItem "gain[0] - " & os.gain(0)
      .AddItem "gain[1] - " & os.gain(1)
      .AddItem "offset[0] - " & os.offset(0)
      .AddItem "offset[1] - " & os.offset(1)
   End With
   ' Clear the list box
   List1.Clear
   List1.AddItem "Collecting..."
   
   lReturn = Acquire("A,1,10", Len(iss), DEFAULT_TIME_OUT, iss)

   Select Case lReturn
      Case NET_IO_SUCCESS

         ' Add to ListBox
         With List1
            .Clear
            .AddItem "Header - " & iss.FR_Header.Header
            .AddItem "Errbyte - " & iss.FR_Header.errbyte
         End With
         
         ' Assign Current drift value
         current_drift = iss.FR_Header.v_Header.drift
         
         If iss.FR_Header.Header = H_NO_ERROR Then
            PlotGraph iss.SpecBuffer
         End If
         

      Case Else
         '
   End Select
   
   ' Clear the list box
   List1.Clear
   List1.AddItem "Collecting Dark Current..."
   '
   ' For Instruments without a shutter, use a dark look up table or prompt to block
   ' light to the detector.
   '
   MsgBox "Please cap the fiber to capture a Dark Current.", vbExclamation + vbOKOnly, "Dark Current"
   '
   ' Close Shutter
   ' Uncomment to following line to close the shutter.
   ' Note: This line will have no effect if there is no shutter in the instrument.
   '
   'lReturn = InstrumentControl("IC,2,3,1", Len(ic), DEFAULT_TIME_OUT, ic)
   '
   ' Acquire the Dark
   '
   lReturn = Acquire("A,1,10", Len(issDarkSpectrum), DEFAULT_TIME_OUT, issDarkSpectrum)
   '
   ' For Instruments without a shutter, prompt the user to allow light in the fiber if
   ' necessary
   '
   MsgBox "Dark Current Complete.  Please uncap fiber.", vbExclamation + vbOKOnly, "Dark Current"
   '
   ' Open Shutter
   ' Uncomment the following line to open the shutter.
   ' Note: This line will have no efect if there is no shutter in the instrument.
   '
   'lReturn = InstrumentControl("IC,2,3,0", Len(ic), DEFAULT_TIME_OUT, ic)

   If issDarkSpectrum.FR_Header.Header = H_NO_ERROR Then
      PlotGraph issDarkSpectrum.SpecBuffer
   End If
   
   ' Assign Dark drift value
   dark_drift = issDarkSpectrum.FR_Header.v_Header.drift
   ' Compute drift
   drift = mlVnirDarkCurrentCorrection + (current_drift - dark_drift)
   '
   ' Subtract the Dark Current - only for the Vnir detector
   '
   For i = 0 To (mlVnirEndingWavelength - mlVnirStartingWavelength)
      iss.SpecBuffer(i) = iss.SpecBuffer(i) - issDarkSpectrum.SpecBuffer(i) + drift
   Next
   
   PlotGraph iss.SpecBuffer
   
   ' Clear the list box
   List1.Clear
   
End Sub

Private Function InstrumentControl(ByVal sCommand As String, _
                                   ByVal packetSize As Long, _
                                   ByVal timeout As Double, _
                                   ic As InstrumentControlStruct) As Long

   Dim lReturn As Long
   Dim alHost() As Long
   
   ' Clear buffers
   ClearNetBuffer
   
   ' Send the Command
   Winsock1.SendData sCommand
   
   ' Wait for Response
   lReturn = WaitForNetIOEvent(packetSize, timeout)
                   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Copy the String buffer to a byte buffer
         ReDim mayNetByteBuffer(packetSize) As Byte
         CopyMemory mayNetByteBuffer(0), ByVal msNetData, packetSize
         
         ' Convert to LittleEndian
         ConvertNetToHostLong mayNetByteBuffer, alHost
         
         ' Put in the InstrumentControlStruct
         ic.Header = alHost(0)
         ic.errbyte = alHost(1)
         ic.detector = alHost(2)
         ic.cmdType = alHost(3)
         ic.value = alHost(4)
         
         InstrumentControl = lReturn
         
      Case NET_IO_TIMEOUT
         MsgBox "Instrument Control " & sCommand & " timed out.", vbOKOnly + vbExclamation, Me.Caption
         InstrumentControl = lReturn
         
      Case NET_IO_ABORT
         InstrumentControl = lReturn
         
   End Select

End Function

Private Sub cmdDisconnect_Click()
   TerminateConnection
   
   List1.Clear
   cmdConnect.Enabled = True
   cmdDisconnect.Enabled = False
   cmdVersion.Enabled = False
   cmdStartWavelength.Enabled = False
   cmdEndWavelength.Enabled = False
   cmdOptimize.Enabled = False
   cmdAcquire.Enabled = False
   cmdDarkCurrent.Enabled = False
   cmdReflectance.Enabled = False
   
End Sub

Private Sub cmdEndWavelength_Click()
   
   Dim lReturn As Long
   Dim ps As ParamStruct
   
   lReturn = GetFlashValue("INIT,0,EndingWavelength", 50, DEFAULT_TIME_OUT, ps)
   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Add to ListBox
         With List1
            .Clear
            .AddItem "Header - " & ps.Header
            .AddItem "Errbyte - " & ps.errbyte
            .AddItem "Name - " & ps.Name
            .AddItem "Value - " & ps.value
            .AddItem "Count - " & ps.Count
         End With
      Case Else
         '
   End Select
End Sub

Private Sub cmdOptimize_Click()

   Dim os As OptimizeStruct
   Dim lReturn As Long
   
   ' Clear the list box
   List1.Clear
   List1.AddItem "Optimizing..."
   InitGraph
   
   lReturn = Optimize("OPT,7", Len(os), DEFAULT_OPTIMIZE_TIME_OUT, os)

   ' Add to ListBox
   With List1
      .Clear
      .AddItem "Header - " & os.Header
      .AddItem "Errbyte - " & os.errbyte
      .AddItem "itime - " & os.itime
      .AddItem "gain[0] - " & os.gain(0)
      .AddItem "gain[1] - " & os.gain(1)
      .AddItem "offset[0] - " & os.offset(0)
      .AddItem "offset[1] - " & os.offset(1)
   End With
   
End Sub

Private Sub cmdReflectance_Click()
   
   Dim ps As ParamStruct
   Dim os As OptimizeStruct
   Dim iss As FRInterpSpecStruct
   Dim issReference As FRInterpSpecStruct
   Dim issDarkSpectrum As FRInterpSpecStruct
   Dim ic As InstrumentControlStruct
   Dim lReturn As Long
   Dim i As Integer
   
   ' Clear the list box
   List1.Clear
   List1.AddItem "Collecting Reference Spectrum..."
   
   lReturn = Acquire("A,1,10", Len(issReference), DEFAULT_TIME_OUT, issReference)

   Select Case lReturn
      Case NET_IO_SUCCESS

         ' Add to ListBox
         With List1
            .Clear
            .AddItem "Header - " & issReference.FR_Header.Header
            .AddItem "Errbyte - " & issReference.FR_Header.errbyte
         End With
         
         If issReference.FR_Header.Header = H_NO_ERROR Then
            PlotGraph issReference.SpecBuffer
         End If
         
      Case Else
         '
   End Select
   
   ' Clear the list box
   List1.Clear
   List1.AddItem "Collecting..."
   
   lReturn = Acquire("A,1,10", Len(iss), DEFAULT_TIME_OUT, iss)

   Select Case lReturn
      Case NET_IO_SUCCESS

         ' Add to ListBox
         With List1
            .Clear
            .AddItem "Header - " & iss.FR_Header.Header
            .AddItem "Errbyte - " & iss.FR_Header.errbyte
         End With
         
         If iss.FR_Header.Header = H_NO_ERROR Then
            PlotGraph iss.SpecBuffer
         End If
         
      Case Else
         '
   End Select
   '
   ' Compute Reflectance
   '
   For i = 0 To UBound(iss.SpecBuffer)
      If issReference.SpecBuffer(i) <> 0 Then
         iss.SpecBuffer(i) = iss.SpecBuffer(i) / issReference.SpecBuffer(i)
      Else
         iss.SpecBuffer(i) = 0
      End If
   Next
      
   PlotGraph iss.SpecBuffer
   
   ' Clear the list box
   List1.Clear
   
   MSChart1.Plot.Axis(VtChAxisIdY, 0).AxisTitle = "Reflectance"
    
End Sub

Private Sub cmdStartWavelength_Click()

   Dim lReturn As Long
   Dim ps As ParamStruct
   
   lReturn = GetFlashValue("INIT,0,StartingWavelength", 50, DEFAULT_TIME_OUT, ps)
   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Add to ListBox
         With List1
            .Clear
            .AddItem "Header - " & ps.Header
            .AddItem "Errbyte - " & ps.errbyte
            .AddItem "Name - " & ps.Name
            .AddItem "Value - " & ps.value
            .AddItem "Count - " & ps.Count
         End With
      Case Else
         '
   End Select
End Sub

Private Function GetFlashValue(ByVal sCommand As String, _
                               ByVal packetSize As Long, _
                               ByVal timeout As Double, _
                               ps As ParamStruct) As Long
   
   Dim lReturn As Long
   Dim alHost() As Long
   Dim lNull As Long
   Dim adValue() As Double
  
   ' Clear buffers
   ClearNetBuffer
   
   ' Send the Command
   Winsock1.SendData sCommand
   
   ' Wait for Response
   lReturn = WaitForNetIOEvent(packetSize, timeout)
   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Copy the String buffer to a byte buffer
         ReDim mayNetByteBuffer(packetSize) As Byte
         CopyMemory mayNetByteBuffer(0), ByVal msNetData, packetSize
                
         ' Put in the ParamStruct
         ' Header and Errbyte
         ReDim ayValue(7) As Byte
         CopyMemory ayValue(0), mayNetByteBuffer(0), 8
         ' Convert to LittleEndian
         ConvertNetToHostLong ayValue, alHost
         ps.Header = alHost(0)
         ps.errbyte = alHost(1)
         
         ' Name
         ps.Name = String(30, Chr(0))
         CopyMemory ByVal ps.Name, mayNetByteBuffer(8), 30
         ' Strip Null Characters
         lNull = InStr(ps.Name, Chr(0))
         If lNull Then
            ps.Name = Left$(ps.Name, lNull - 1)
         End If
         
         ' Value
         ReDim ayValue(7) As Byte
         CopyMemory ayValue(0), mayNetByteBuffer(38), 8
         ' Convert to a Double Value
         ConvertNetToHostDouble ayValue, adValue
         ps.value = adValue(0)
         
         ' Count
         ReDim ayValue(3) As Byte
         CopyMemory ayValue(0), mayNetByteBuffer(46), 4
         ' Convert to LittleEndian
         ConvertNetToHostLong ayValue, alHost
         ps.Count = alHost(0)
         
         GetFlashValue = lReturn
         
      Case NET_IO_ABORT, NET_IO_TIMEOUT
         MsgBox "Unable to Get Flash Value for " & sCommand, vbOKOnly + vbExclamation, Me.Caption
         GetFlashValue = lReturn
   End Select

End Function

Private Function RestoreFlash(ByVal sCommand As String, _
                              ByVal packetSize As Long, _
                              ByVal timeout As Double) As Long
   
   Dim lReturn As Long
   Dim alHost() As Long
   Dim lNull As Long
   Dim adValue() As Double
   Dim hs As HeaderStruct
   
   ' Clear buffers
   ClearNetBuffer
   
   ' Send the Command
   Winsock1.SendData sCommand
   
   ' Wait for Response
   lReturn = WaitForNetIOEvent(packetSize, timeout)
   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Copy the String buffer to a byte buffer
         ReDim mayNetByteBuffer(packetSize) As Byte
         CopyMemory mayNetByteBuffer(0), ByVal msNetData, packetSize
                
         ' Put in the ParamStruct
         ' Header and Errbyte
         ReDim ayValue(7) As Byte
         CopyMemory ayValue(0), mayNetByteBuffer(0), 8
         ' Convert to LittleEndian
         ConvertNetToHostLong ayValue, alHost
         hs.Header = alHost(0)
         hs.errbyte = alHost(1)
         
         RestoreFlash = lReturn
         
      Case NET_IO_ABORT, NET_IO_TIMEOUT
         MsgBox "Unable to Restore Flash " & sCommand, vbOKOnly + vbExclamation, Me.Caption
         RestoreFlash = lReturn
   End Select

End Function

Private Function ConvertNetToHostLong(ayNet() As Byte, alHost() As Long) As Boolean

   Dim nByte As Integer
   Dim nHostByte As Integer
   Dim lNet As Long
   Dim lHost As Long

   ' Size the Destination Array
   ReDim alHost(UBound(ayNet) / 4) As Long
   
   ' Loop through the Byte Array and convert to LittleEndian
   For nByte = 0 To UBound(ayNet) Step 4
      ' Copy 4 bytes into a Long
      CopyMemory lNet, ayNet(nByte), Len(lNet)
      ' Do the LittleEndian swap - from ws2_32.dll
      lHost = NetToHostLong(lNet)
      'Debug.Print "ConvertNetToHostLong "; lNet; lHost
      ' Store the value in the the Long Array
      alHost(nHostByte) = lHost
      nHostByte = nHostByte + 1
   Next
   
   ConvertNetToHostLong = True
   
   
End Function

Public Function ConvertNetToHostDouble(ayNet() As Byte, adHost() As Double) As Boolean
                     
   Dim dTemp As Double
   Dim lTemp As Long
   Dim bedBigEndian As BigEndianDouble
   Dim nValue As Integer
   Dim nDWORD As Integer
   Dim dValue As Double
      
   ' Allocate memory
   ReDim alHost(UBound(ayNet) / 4) As Long
   
   ' Convert array to LittleEndian
   If ConvertNetToHostLong(ayNet, alHost) Then
      ' Allocate memory
      ReDim adHost(UBound(alHost) / 2) As Double
      
      For nDWORD = 0 To (UBound(alHost) - 1) Step 2
         bedBigEndian.MSDWord = alHost(nDWORD)
         bedBigEndian.LSDWord = alHost(nDWORD + 1)
         '
         ' Swap DWORDS
         '
         With bedBigEndian
            lTemp = .MSDWord
            .MSDWord = .LSDWord
            .LSDWord = lTemp
         End With
         ' Copy into temp value
         CopyMemory dValue, bedBigEndian, Len(dValue)
         ' Store in Array
         adHost(nValue) = dValue
         nValue = nValue + 1
      Next
      ConvertNetToHostDouble = True
   End If
   
End Function

Private Sub cmdVersion_Click()
   Dim lReturn As Long
   Dim ps As ParamStruct
   
   lReturn = GetFlashValue("V", 50, DEFAULT_TIME_OUT, ps)
   
   Select Case lReturn
      Case NET_IO_SUCCESS
         ' Add to ListBox
         With List1
            .Clear
            .AddItem "Header - " & ps.Header
            .AddItem "Errbyte - " & ps.errbyte
            .AddItem "Name - " & ps.Name
            .AddItem "Value - " & ps.value
            .AddItem "Type - " & ps.Count
         End With
      Case Else
         '
   End Select
End Sub


Private Sub Form_Load()
   
   List1.Clear
   cmdConnect.Enabled = True
   cmdDisconnect.Enabled = False
   cmdVersion.Enabled = False
   cmdStartWavelength.Enabled = False
   cmdEndWavelength.Enabled = False
   cmdOptimize.Enabled = False
   cmdAcquire.Enabled = False
   cmdDarkCurrent.Enabled = False
   cmdReflectance.Enabled = False
   
   InitGraph
   
End Sub

Private Sub InitGraph()


   With MSChart1
      
      .chartType = VtChChartType2dLine
      .ColumnCount = 1
      
      .Column = 1
      .Row = 1
      
      .Plot.Axis(VtChAxisIdX, 0).AxisTitle.Text = "Wavelength"
      .Plot.Axis(VtChAxisIdY, 0).AxisTitle.Text = "RawDN"
      .Plot.Axis(VtChAxisIdX, 0).Tick.Style = VtChAxisTickStyleNone
      .Plot.Axis(VtChAxisIdY, 0).Tick.Style = VtChAxisTickStyleNone
      .Plot.Axis(VtChAxisIdX, 0).AxisScale.Type = VtChScaleTypeLinear
      .Plot.DataSeriesInRow = True
      .Plot.UniformAxis = False
   
      .Refresh
   End With
   
End Sub

Private Sub PlotGraph(asngData() As Single)
   
   With MSChart1
      .ChartData = asngData
      .Refresh
   End With
   
End Sub
Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
   
   Dim sData As String
    
   Select Case Winsock1.State
      Case sckConnected
         mlNetBytesRead = mlNetBytesRead + bytesTotal
         Debug.Print bytesTotal; mlNetBytesRead
         sData = String(bytesTotal, Chr(0))
         Winsock1.GetData sData, vbArray + vbByte, mlNetBytesRead
         msNetData = msNetData & sData
         
      Case Else
         '
   End Select
End Sub

