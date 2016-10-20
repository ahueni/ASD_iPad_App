; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CTCPClientDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "TCPClient.h"

ClassCount=3
Class1=CTCPClientApp
Class2=CTCPClientDlg
Class3=CAboutDlg

ResourceCount=3
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_TCPCLIENT_DIALOG

[CLS:CTCPClientApp]
Type=0
HeaderFile=TCPClient.h
ImplementationFile=TCPClient.cpp
Filter=N

[CLS:CTCPClientDlg]
Type=0
HeaderFile=TCPClientDlg.h
ImplementationFile=TCPClientDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=CTCPClientDlg

[CLS:CAboutDlg]
Type=0
HeaderFile=TCPClientDlg.h
ImplementationFile=TCPClientDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_TCPCLIENT_DIALOG]
Type=1
Class=CTCPClientDlg
ControlCount=12
Control1=IDOK,button,1342242817
Control2=IDC_CONNECT,button,1342242816
Control3=IDC_DISCONNECT,button,1342242816
Control4=IDC_VERSION,button,1342242816
Control5=IDC_GET_STARTING_WAVELENGTH,button,1342242816
Control6=IDC_GET_ENDING_WAVELENGTH,button,1342242816
Control7=IDC_OPTIMIZE,button,1342242816
Control8=IDC_AQUIRE,button,1342242816
Control9=IDC_DARK_CORRECTED_SPECTRUM,button,1342242816
Control10=IDC_REFLECTANCE,button,1342242816
Control11=IDC_NORMALIZED_SPECTRUM,button,1342242816
Control12=IDC_HEADER,listbox,1352728833

