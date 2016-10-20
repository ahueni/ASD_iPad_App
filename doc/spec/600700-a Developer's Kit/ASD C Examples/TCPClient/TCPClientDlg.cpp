// TCPClientDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TCPClient.h"
#include "TCPClientDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTCPClientDlg dialog

CTCPClientDlg::CTCPClientDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTCPClientDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CTCPClientDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_iStartingWavelength = 350;
	m_iEndingWavelength = 2500;
	m_iVnirEndingWavelength = 0;
	m_yMin = 0;
	m_yMax = 65535;
	m_sYCaption = "rawDN";
	m_sXCaption = "Wavelength";
	m_xInterval = 5;
	m_yInterval = 5;
	m_xPrecision = 0;
	m_yPrecision = 0;
	m_yLock = FALSE;
	m_xLock = FALSE;
}

CTCPClientDlg::~CTCPClientDlg()
{
	ReleaseObjects();
}

void CTCPClientDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTCPClientDlg)
	DDX_Control(pDX, IDC_VERSION, m_Version);
	DDX_Control(pDX, IDC_REFLECTANCE, m_Reflectance);
	DDX_Control(pDX, IDC_OPTIMIZE, m_Optimize);
	DDX_Control(pDX, IDC_NORMALIZED_SPECTRUM, m_Normalize);
	DDX_Control(pDX, IDC_GET_STARTING_WAVELENGTH, m_EndingWavelength);
	DDX_Control(pDX, IDC_GET_ENDING_WAVELENGTH, m_StartingWavelength);
	DDX_Control(pDX, IDC_DARK_CORRECTED_SPECTRUM, m_DarkCorrectedSpectrum);
	DDX_Control(pDX, IDC_AQUIRE, m_Acquire);
	DDX_Control(pDX, IDC_DISCONNECT, m_Disconnect);
	DDX_Control(pDX, IDC_CONNECT, m_Connect);
	DDX_Control(pDX, IDC_HEADER, m_Header);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CTCPClientDlg, CDialog)
	//{{AFX_MSG_MAP(CTCPClientDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_AQUIRE, OnAcquire)
	ON_BN_CLICKED(IDC_CONNECT, OnConnect)
	ON_BN_CLICKED(IDC_DARK_CORRECTED_SPECTRUM, OnDarkCorrectedSpectrum)
	ON_BN_CLICKED(IDC_DISCONNECT, OnDisconnect)
	ON_BN_CLICKED(IDC_GET_ENDING_WAVELENGTH, OnGetEndingWavelength)
	ON_BN_CLICKED(IDC_GET_STARTING_WAVELENGTH, OnGetStartingWavelength)
	ON_BN_CLICKED(IDC_NORMALIZED_SPECTRUM, OnNormalizeSpectrum)
	ON_BN_CLICKED(IDC_OPTIMIZE, OnOptimize)
	ON_BN_CLICKED(IDC_REFLECTANCE, OnReflectance)
	ON_BN_CLICKED(IDC_VERSION, OnVersion)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTCPClientDlg message handlers

BOOL CTCPClientDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	//  create the line plot control.
	m_LinePlot.Create(CRect(10, 10, 635, 385), WS_CHILD | WS_VISIBLE, this, ID_CTRL_LINE_PLOT);
	InitGraph();
	
	// Disable buttons
	m_Connect.EnableWindow(TRUE);
	m_Disconnect.EnableWindow(FALSE);
	m_Version.EnableWindow(FALSE);
	m_StartingWavelength.EnableWindow(FALSE);
	m_EndingWavelength.EnableWindow(FALSE);
	m_Optimize.EnableWindow(FALSE);
	m_Acquire.EnableWindow(FALSE);
	m_DarkCorrectedSpectrum.EnableWindow(FALSE);
	m_Reflectance.EnableWindow(FALSE);
	m_Normalize.EnableWindow(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CTCPClientDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CTCPClientDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CTCPClientDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CTCPClientDlg::OnConnect() 
{
	
	//
	// Initialize WSA
	//
	if(WSAStartup(MAKEWORD(2,2), &WsaDat)!=0)
	{
		printf("WSA Initialization failed.");
		return;
	}
	//
	// Create Socket
	//
	Socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP );

	if(Socket == INVALID_SOCKET)
	{
		printf("Socket creation failed.");
	}
	//
	// Connect to TCP Server
	//
	SOCKADDR_IN SockAddr;
	// Port for the TCP Server is 8080
	SockAddr.sin_port = htons(8080);
	SockAddr.sin_family = AF_INET;
	// Change the IP Address from 10.1.1.11 to the set IP Address
	// if different
	SockAddr.sin_addr.S_un.S_addr = inet_addr("10.1.1.11");
	
	m_Header.ResetContent();
	m_Header.AddString("Connecting...");
	m_Header.Invalidate();
	m_Header.UpdateWindow();

	int RetVal = connect(Socket, (SOCKADDR *)(&SockAddr), sizeof(SockAddr));
	if(RetVal != 0)
	{
		int l = WSAGetLastError();
		printf("Failed to establish connection with server. %d\n", l);

	}

	char recvbuf[70] = "";
	char totalbuf[70] = "";
	int bytesRecv = SOCKET_ERROR;
    int totalRecv = 0;


	while( totalRecv < 50 ) 
	{
        
		bytesRecv = recv( Socket, recvbuf, 70, 0 );
		
		if (bytesRecv == SOCKET_ERROR)
		{
			AfxMessageBox("Unable to Connect", MB_OK | MB_ICONEXCLAMATION);
			m_Header.ResetContent();
			return;

		}

        if ( bytesRecv == 0 || bytesRecv == WSAECONNRESET ) 
		{
            printf( "Connection Closed.\n");
            return;
        }
 
		totalRecv +=bytesRecv;
        strcat(totalbuf, recvbuf);
        printf( "Bytes Recv: %ld\n", bytesRecv );
		if (totalRecv > 50)
        break;
	}

	m_Header.ResetContent();

	m_Connect.EnableWindow(FALSE);
	m_Disconnect.EnableWindow(TRUE);
	m_Version.EnableWindow(TRUE);
	m_StartingWavelength.EnableWindow(TRUE);
	m_EndingWavelength.EnableWindow(TRUE);
	m_Optimize.EnableWindow(TRUE);
	m_Acquire.EnableWindow(TRUE);
	m_DarkCorrectedSpectrum.EnableWindow(TRUE);
	m_Reflectance.EnableWindow(TRUE);
	m_Normalize.EnableWindow(TRUE);

	AfxMessageBox((char *)totalbuf, MB_OK | MB_ICONINFORMATION);

	return;

}

void CTCPClientDlg::OnDisconnect() 
{
	
	m_Header.ResetContent();

	m_Connect.EnableWindow(TRUE);
	m_Disconnect.EnableWindow(FALSE);
	m_Version.EnableWindow(FALSE);
	m_StartingWavelength.EnableWindow(FALSE);
	m_EndingWavelength.EnableWindow(FALSE);
	m_Optimize.EnableWindow(FALSE);
	m_Acquire.EnableWindow(FALSE);
	m_DarkCorrectedSpectrum.EnableWindow(FALSE);
	m_Reflectance.EnableWindow(FALSE);
	m_Normalize.EnableWindow(FALSE);

	ReleaseObjects();

	m_Connect.EnableWindow(TRUE);

	return;
}

void CTCPClientDlg::OnVersion() 
{


	int bytesSent = 0;
	CString strCommand("V");
	unsigned char totalbuf[sizeof(VersionStruct)] = "";
	int totalBytesRecv = 0;
	
	VersionStruct *vs;
	
    bytesSent = send( Socket, strCommand, strCommand.GetLength(), 0 );
   
	WaitForIOEvent(sizeof(*vs),totalbuf, &totalBytesRecv);

	unsigned char *p = &totalbuf[0];
	vs = (VersionStruct *)malloc(sizeof(*vs));

	memcpy(vs, p, sizeof(*vs));

	vs->Header = ntohl(vs->Header);
	vs->errbyte = ntohl(vs->errbyte);


	m_Header.ResetContent();

	CString s;
	s.Format("Header->%d",vs->Header);
	m_Header.AddString(s);

	s.Format("errbyte->%d",vs->errbyte);
	m_Header.AddString(s);

	s.Format("Version Str->%s", vs->version);
	m_Header.AddString(s);

	s.Format("Version Value->%.2f", swapWord(vs->value));
	m_Header.AddString(s);
	return;

	
}

void CTCPClientDlg::WaitForIOEvent(int bytesToRecv, unsigned char *recvBuf, int *totalBytesRecv)
{

	int bytesRecv = 0;
	char *recvbuf = new char[bytesToRecv];
	//int totalBytesRecv = 0;
	
	*totalBytesRecv = 0;

    while( *totalBytesRecv < bytesToRecv) 
	{
		bytesRecv = recv( Socket, recvbuf, bytesToRecv, 0 );
		if (bytesRecv == SOCKET_ERROR)
			break;

		if ( bytesRecv == 0 || bytesRecv == WSAECONNRESET ) {
            printf( "Connection Closed.\n");
            break;
        }
        printf( "Bytes Recv: %ld\n", bytesRecv );
		
		memmove(&recvBuf[*totalBytesRecv], recvbuf, bytesRecv);

		*totalBytesRecv += bytesRecv;
	}

	delete recvbuf;

	return;

}

void CTCPClientDlg::ReleaseObjects()
{

	//
	// Close the Socket
	// 
	closesocket(Socket);

	//
	// Clean of the Winsock library
	//
	WSACleanup();
	
	//
	// Clean up graph object
	//
	m_LinePlot.Clear();

	return;
}


void CTCPClientDlg::OnAcquire() 
{
	
	m_sYCaption = "rawDN";
	m_sXCaption = "Wavelength";
	m_yMin = 0;
	m_yMax = 65535;


	CString s = "Collecting...";
	m_Header.ResetContent();
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();
	InitGraph();

	FRSpecStruct *iss;

	iss = (FRSpecStruct *)malloc(sizeof(*iss));

	Acquire(iss, "A,1,10");

	iss->FRHeader.Header = ntohl(iss->FRHeader.Header);
	iss->FRHeader.errbyte = ntohl(iss->FRHeader.errbyte);

	m_Header.ResetContent();

	s.Format("Header->%d",iss->FRHeader.Header);
	m_Header.AddString(s);

	s.Format("errbyte->%d",iss->FRHeader.errbyte);
	m_Header.AddString(s);

	if(iss->FRHeader.Header == H_NO_ERROR)
	{
		
		ConvertToFloat(iss);

		COLORREF crColor = RGB(0,0,255);
		PlotData(&iss->SpecBuffer[0].f, sizeof(iss->SpecBuffer) / sizeof(float), "DN", crColor);
	}

	free(iss);

	return;
        	
}
 

void CTCPClientDlg::PlotData(float *SpecBuffer, int uPoints, CString strKey, COLORREF crColor)
{

	UINT ii;
    
	//  add a plot to the control.

	FLOATPOINT *pData2 = new FLOATPOINT[uPoints];
	
	for (ii=0; ii<uPoints; ii++)
	{
		pData2[ii].x = (float)(ii + m_iStartingWavelength);
		pData2[ii].y = SpecBuffer[ii];
	}
	COLORREF crColor2 = RGB (0, 0, 255);
	

	m_LinePlot.Add(strKey, crColor, CLinePlot::LpLine, pData2, uPoints);

	delete pData2;

	return;
}

void CTCPClientDlg::InitGraph()
{


	float xMin = (float)m_iStartingWavelength;
	float xMax = (float)m_iEndingWavelength;
	bool yLock = FALSE;

	m_LinePlot.Clear();
	m_LinePlot.SetIsYLocked(yLock);
	m_LinePlot.SetXMin(xMin);
	m_LinePlot.SetXMax(xMax);
	m_LinePlot.SetYMin(m_yMin);
	m_LinePlot.SetYMax(m_yMax);
	m_LinePlot.SetXIntervals(m_xInterval);
	m_LinePlot.SetYIntervals(m_yInterval);
	m_LinePlot.SetXPrecision(m_xPrecision);
	m_LinePlot.SetYPrecision(m_yPrecision);
	m_LinePlot.SetXCaption(m_sXCaption);
	m_LinePlot.SetYCaption(m_sYCaption);
	m_LinePlot.SetIsYLocked(m_yLock);

	return;
	
}

void CTCPClientDlg::OnOptimize() 
{

	OptimizeStruct *os;

	CString s = "Optimizing...";
	m_Header.ResetContent();
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();

	os = (OptimizeStruct *)malloc(sizeof(*os));

	OptimizeInstrument(os, "OPT,7");

	m_Header.ResetContent();

	s.Format("Header->%d",ntohl(os->Header));
	m_Header.AddString(s);

	s.Format("errbyte->%d",ntohl(os->errbyte));
	m_Header.AddString(s);

	s.Format("itime->%d", ntohl(os->itime));
	m_Header.AddString(s);
	
	s.Format("gain[0]->%d", ntohl(os->gain[0]));
	m_Header.AddString(s);

	s.Format("gain[1]->%d", ntohl(os->gain[1]));
	m_Header.AddString(s);
	
	s.Format("offset[0]->%d", ntohl(os->offset[0]));
	m_Header.AddString(s);

	s.Format("offset[1]->%d", ntohl(os->offset[1]));
	m_Header.AddString(s);

	free(os);

	return;
	
}

void CTCPClientDlg::OnGetStartingWavelength() 
{
	
	ParamStruct *ps;
	ps = (ParamStruct *)malloc(sizeof(*ps));

	GetFlashValue(ps, "INIT,0,StartingWavelength");

	m_Header.ResetContent();

	CString s;
	s.Format("Header->%d",ntohl(ps->Header));
	m_Header.AddString(s);

	s.Format("errbyte->%d",ntohl(ps->errbyte));
	m_Header.AddString(s);

	s.Format("Name->%s", ps->name);
	m_Header.AddString(s);
	
	s.Format("value->%.0f", swapWord(ps->value));
	m_Header.AddString(s);
	
	s.Format("count->%d", ntohl(ps->count));
	m_Header.AddString(s);

	free(ps);

	return;

}

double CTCPClientDlg::swapWord(double dNumber)
{
	union dv un;
	union dv vn;

	un.d = 0;
	un.d  = dNumber;

	vn.l[0] = ntohl(un.l[1]);
	vn.l[1] = ntohl(un.l[0]);

	return vn.d;


}

void CTCPClientDlg::GetFlashValue(ParamStruct *ps, CString strCommand)
{
	
	int bytesSent = 0;
	unsigned char totalbuf[sizeof(ParamStruct)] = "";
	int totalBytesRecv = 0;

    bytesSent = send( Socket, strCommand, strCommand.GetLength(), 0 );

	WaitForIOEvent(sizeof(*ps), totalbuf, &totalBytesRecv);

	unsigned char *p = &totalbuf[0];

	memcpy(ps, p, sizeof(*ps));

	return;

}

void CTCPClientDlg::OnGetEndingWavelength() 
{
	

	ParamStruct *ps;
	ps = (ParamStruct *)malloc(sizeof(*ps));

	GetFlashValue(ps, "INIT,0,EndingWavelength");

	m_Header.ResetContent();

	CString s;
	s.Format("Header->%d",ntohl(ps->Header));
	m_Header.AddString(s);

	s.Format("errbyte->%d",ntohl(ps->errbyte));
	m_Header.AddString(s);

	s.Format("Name->%s", ps->name);
	m_Header.AddString(s);
	
	s.Format("value->%.0f", swapWord(ps->value));
	m_Header.AddString(s);
	
	s.Format("count->%d", ntohl(ps->count));
	m_Header.AddString(s);

	free(ps);

	return;
}

void CTCPClientDlg::OnDarkCorrectedSpectrum() 
{
	
	CString s;
	COLORREF crColor;

	m_sYCaption = "rawDN";
	m_sXCaption = "Wavelength";
	m_yMin = 0;
	m_yMax = 65535;
	m_yInterval = 5;
	m_yPrecision = 0;

	InitGraph();
	// Get Starting/Ending Wavelength
	if(m_iVnirEndingWavelength == 0)
	{
		ParamStruct *ps;

		ps = (ParamStruct *)malloc(sizeof(*ps));

		GetFlashValue(ps, "INIT,0,StartingWavelength");
		m_iStartingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,EndingWavelength");
		m_iEndingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,VEndingWavelength");
		m_iVnirEndingWavelength = (int)swapWord(ps->value);
	}

	// Clear the list box
	m_Header.ResetContent();

	// Optimize
	s = "Optimizing...";
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();

	OptimizeStruct *os;

	os = (OptimizeStruct *)malloc(sizeof(*os));

	OptimizeInstrument(os, "OPT,7");

	FRSpecStruct *iss;

	iss = (FRSpecStruct *)malloc(sizeof(*iss));

	Acquire(iss, "A,1,10");

	iss->FRHeader.Header = ntohl(iss->FRHeader.Header);
	iss->FRHeader.errbyte = ntohl(iss->FRHeader.errbyte);

	if(iss->FRHeader.Header == H_NO_ERROR)
	{
		ConvertToFloat(iss);

		crColor = RGB(0,255,0);
		PlotData(&iss->SpecBuffer[0].f, 
			     sizeof(iss->SpecBuffer) / sizeof(float), 
				 "Non-Dark Corrected", 
				 crColor);
	}
	// Close Shutter
	m_Header.ResetContent();
	s = "Collecting Dark Current...";
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();

	FRSpecStruct *issDarkSpectrum;

	issDarkSpectrum = (FRSpecStruct *)malloc(sizeof(*issDarkSpectrum));
	
	//Acquire(m_issDarkSpectrum, "A,5,1");

	// Alternative Shutter Command
	InstrumentControlStruct *ics;

	ics = (InstrumentControlStruct*)malloc(sizeof(*ics));

	InstrumentControl(ics, "IC,2,3,1");
	Acquire(issDarkSpectrum, "A,1,10");

	issDarkSpectrum->FRHeader.Header = ntohl(issDarkSpectrum->FRHeader.Header);
	issDarkSpectrum->FRHeader.errbyte = ntohl(issDarkSpectrum->FRHeader.errbyte);

	if(issDarkSpectrum->FRHeader.Header == H_NO_ERROR)
	{
		ConvertToFloat(issDarkSpectrum);
		crColor = RGB(255,0,0);
		PlotData(&issDarkSpectrum->SpecBuffer[0].f, 
			     sizeof(issDarkSpectrum->SpecBuffer) / sizeof(float), 
				 "Dark", 
				 crColor);
		m_LinePlot.Invalidate();
		m_LinePlot.UpdateWindow();
	}
	// Open Shutter
	//Acquire(iss, "A,5,0");

	// Alternative Shutter Command
	InstrumentControl(ics, "IC,2,3,0");

	// Acquire
	m_Header.ResetContent();
	s = "Collecting...";
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();

	Acquire(iss, "A,1,10");

	iss->FRHeader.Header = ntohl(iss->FRHeader.Header);
	iss->FRHeader.errbyte = ntohl(iss->FRHeader.errbyte);

	m_Header.ResetContent();
	s.Format("Header->%d",iss->FRHeader.Header);
	m_Header.AddString(s);

	s.Format("errbyte->%d",iss->FRHeader.errbyte);
	m_Header.AddString(s);

	if(iss->FRHeader.Header == H_NO_ERROR)
	{
		ConvertToFloat(iss);

		// Subtract dark
		for(int i = 0; i < ((m_iVnirEndingWavelength + 1) - m_iStartingWavelength); i++)
			iss->SpecBuffer[i].f -= issDarkSpectrum->SpecBuffer[i].f;

		crColor = RGB(0,0,255);
		PlotData(&iss->SpecBuffer[0].f, 
			     sizeof(iss->SpecBuffer) / sizeof(float), 
				 "Dark Corrected", 
				 crColor);
	}


	free(os);
	free(iss);
	free(ics);
	free(issDarkSpectrum);
}

void CTCPClientDlg::ConvertToFloat(FRSpecStruct *iss)
{
	unsigned long z; 
	
	for(int i=0;i<(sizeof(iss->SpecBuffer) / sizeof(float));i++)
	{
		z = ntohl(iss->SpecBuffer[i].i);
		memcpy(&iss->SpecBuffer[i].f,&z,sizeof(float));
	}
}

void CTCPClientDlg::OptimizeInstrument(OptimizeStruct *os, CString strCommand)
{

	int bytesSent = 0;
	unsigned char totalbuf[sizeof(OptimizeStruct)] = "";
	int totalBytesRecv = 0;

    bytesSent = send( Socket, strCommand, strCommand.GetLength(), 0 );

	WaitForIOEvent(sizeof(*os), totalbuf, &totalBytesRecv);

	unsigned char *p = &totalbuf[0];
	memcpy(os, p, sizeof(*os));

	return;

}

void CTCPClientDlg::Acquire(FRSpecStruct *iss, CString strCommand)
{

	int bytesSent = 0;

	unsigned char totalbuf[sizeof(FRSpecStruct)] = "";
	int totalBytesRecv = 0;
   
    bytesSent = send( Socket, strCommand, strCommand.GetLength(), 0 );
    printf( "Bytes Sent: %ld\n", bytesSent );

	WaitForIOEvent(sizeof(*iss), totalbuf, &totalBytesRecv);

	unsigned char *p = &totalbuf[0];
	
	memcpy(iss, p, sizeof(*iss));

	return;

}

void CTCPClientDlg::InstrumentControl(InstrumentControlStruct *ics, CString strCommand)
{

	int bytesSent = 0;

	unsigned char totalbuf[sizeof(InstrumentControlStruct)] = "";
	int totalBytesRecv = 0;
   
    bytesSent = send( Socket, strCommand, strCommand.GetLength(), 0 );
    printf( "Bytes Sent: %ld\n", bytesSent );

	WaitForIOEvent(sizeof(*ics), totalbuf, &totalBytesRecv);

	unsigned char *p = &totalbuf[0];
	
	memcpy(ics, p, sizeof(*ics));

	return;

}

void CTCPClientDlg::OnReflectance() 
{

	CString s;
	COLORREF crColor;

	m_sYCaption = "Reflectance";
	m_sXCaption = "Wavelength";
	m_yPrecision = 1;
	m_yMin = -1.0;
	m_yMax = 2.0;
	m_yInterval = 5;
	m_yLock = TRUE;

	InitGraph();

	// Get Starting/Ending Wavelength
	if(m_iVnirEndingWavelength == 0)
	{
		ParamStruct *ps;

		ps = (ParamStruct *)malloc(sizeof(*ps));

		GetFlashValue(ps, "INIT,0,StartingWavelength");
		m_iStartingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,EndingWavelength");
		m_iEndingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,VEndingWavelength");
		m_iVnirEndingWavelength = (int)swapWord(ps->value);
	}

	// Clear the list box
	m_Header.ResetContent();

	m_Header.ResetContent();
	s = "Collecting Reference...";
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();

	// Collect Reference Spectrum
	FRSpecStruct *issReference;

	issReference = (FRSpecStruct *)malloc(sizeof(*issReference));

	Acquire(issReference, "A,1,10");
	
	issReference->FRHeader.Header = ntohl(issReference->FRHeader.Header);
	issReference->FRHeader.errbyte = ntohl(issReference->FRHeader.errbyte);

	if(issReference->FRHeader.Header == H_NO_ERROR)
	{
		ConvertToFloat(issReference);
		//crColor = RGB(255,0,0);
		//PlotData(&issReference->SpecBuffer[0].f, 
		//	     sizeof(issReference->SpecBuffer) / sizeof(float), 
		//		 "Reference", 
		//		 crColor);
		//m_LinePlot.Invalidate();
		//m_LinePlot.UpdateWindow();
	}

	// Collect Spectrum
	m_Header.ResetContent();
	s = "Collecting...";
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();
	
	FRSpecStruct *iss;

	iss = (FRSpecStruct *)malloc(sizeof(*iss));

	Acquire(iss, "A,1,10");

	iss->FRHeader.Header = ntohl(iss->FRHeader.Header);
	iss->FRHeader.errbyte = ntohl(iss->FRHeader.errbyte);

	m_Header.ResetContent();
	s.Format("Header->%d",iss->FRHeader.Header);
	m_Header.AddString(s);

	s.Format("errbyte->%d",iss->FRHeader.errbyte);
	m_Header.AddString(s);

	if(iss->FRHeader.Header == H_NO_ERROR)
	{
		ConvertToFloat(iss);

		// Compute Reflectance
		for(int i = 0; i < ((m_iEndingWavelength + 1) - m_iStartingWavelength); i++)
			iss->SpecBuffer[i].f = iss->SpecBuffer[i].f/ issReference->SpecBuffer[i].f;
		
		crColor = RGB(0,0,255);
		PlotData(&iss->SpecBuffer[0].f, 
			     sizeof(iss->SpecBuffer) / sizeof(float), 
				 "Reflectance", 
				 crColor);
	}

	free(iss);
	free(issReference);
}

void CTCPClientDlg::OnNormalizeSpectrum() 
{
	
	CString s;
	COLORREF crColor;

	m_sYCaption = "rawDN";
	m_sXCaption = "Wavelength";
	m_yPrecision = 0;
	m_yMin = 0;
	m_yMax = 65535;
	m_yInterval = 5;
	m_yLock = TRUE;

	InitGraph();

	// Get Starting/Ending Wavelength
	if(m_iVnirEndingWavelength == 0)
	{
		ParamStruct *ps;

		ps = (ParamStruct *)malloc(sizeof(*ps));

		GetFlashValue(ps, "INIT,0,StartingWavelength");
		m_iStartingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,EndingWavelength");
		m_iEndingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,VEndingWavelength");
		m_iVnirEndingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,S1EndingWavelength");
		m_iSwir1EndingWavelength = (int)swapWord(ps->value);

		GetFlashValue(ps, "INIT,0,S2EndingWavelength");
		m_iSwir2EndingWavelength = (int)swapWord(ps->value);
	}

	// Clear the list box
	m_Header.ResetContent();

	// Optimize
	s = "Optimizing...";
	m_Header.AddString(s);
	m_Header.Invalidate();
	m_Header.UpdateWindow();
	OptimizeStruct *os;

	os = (OptimizeStruct *)malloc(sizeof(*os));

	OptimizeInstrument(os, "OPT,7");

	m_Header.ResetContent();

	s.Format("Header->%d",ntohl(os->Header));
	m_Header.AddString(s);

	s.Format("errbyte->%d",ntohl(os->errbyte));
	m_Header.AddString(s);

	int it = ntohl(os->itime);
	s.Format("itime->%d", it);
	m_Header.AddString(s);
	
	int s1g = ntohl(os->gain[0]);
	s.Format("gain[0]->%d", s1g);
	m_Header.AddString(s);

	int s2g = ntohl(os->gain[1]);
	s.Format("gain[1]->%d", s2g);
	m_Header.AddString(s);
	
	s.Format("offset[0]->%d", ntohl(os->offset[0]));
	m_Header.AddString(s);

	s.Format("offset[1]->%d", ntohl(os->offset[1]));
	m_Header.AddString(s);

	m_Header.Invalidate();
	m_Header.UpdateWindow();

	FRSpecStruct *iss;
	FRSpecStruct *issNormalize;

	iss = (FRSpecStruct*)malloc(sizeof(*iss));
	issNormalize = (FRSpecStruct*)malloc(sizeof(*issNormalize));

	Acquire(iss, "A,1,10");

	iss->FRHeader.Header = ntohl(iss->FRHeader.Header);
	iss->FRHeader.errbyte = ntohl(iss->FRHeader.errbyte);


	if(iss->FRHeader.Header == H_NO_ERROR)
	{
	
		ConvertToFloat(iss);
		
		crColor = RGB(255,0,0);
		PlotData(&iss->SpecBuffer[0].f, 
			     sizeof(iss->SpecBuffer) / sizeof(float), 
				 "Non-Normalized", 
				 crColor);

		m_LinePlot.Invalidate();
		m_LinePlot.UpdateWindow();

		int i;
		// Normalize Vnir to IT-17ms 
		for(i = 0; i < ((m_iVnirEndingWavelength + 1) - m_iStartingWavelength); i++)
			issNormalize->SpecBuffer[i].f = iss->SpecBuffer[i].f/ (1<<it);

		// Normalize Swir1 Gain to 4096
		float gc = 256;
		float n = s1g/gc;
		for(i = (m_iVnirEndingWavelength + 1) - m_iStartingWavelength; 
			i < ((m_iSwir1EndingWavelength + 1) - m_iStartingWavelength); i++)
			issNormalize->SpecBuffer[i].f = iss->SpecBuffer[i].f * n;

		// Normalize  Swir2 Gain to 4096
		n = s2g/gc;
		for(i = (m_iSwir1EndingWavelength + 1) - m_iStartingWavelength;
			i < ((m_iSwir2EndingWavelength + 1) - m_iStartingWavelength); i++)
			issNormalize->SpecBuffer[i].f = iss->SpecBuffer[i].f * n ;

		crColor = RGB(0,0,255);
		PlotData(&issNormalize->SpecBuffer[0].f, 
			     sizeof(issNormalize->SpecBuffer) / sizeof(float), 
				 "Normalized", 
				 crColor);


		m_LinePlot.Invalidate();
		m_LinePlot.UpdateWindow();
	}

	free(issNormalize);
	free(iss);
	free(os);
}


