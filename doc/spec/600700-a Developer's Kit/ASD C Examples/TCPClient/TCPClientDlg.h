// TCPClientDlg.h : header file
//

#if !defined(AFX_TCPCLIENTDLG_H__AA074DEF_1977_45EA_A9A5_FA98CBE8BB5C__INCLUDED_)
#define AFX_TCPCLIENTDLG_H__AA074DEF_1977_45EA_A9A5_FA98CBE8BB5C__INCLUDED_

#define ID_CTRL_LINE_PLOT (WM_USER+1001)

#if _MSC_VER > 1000
#pragma once
#pragma pack(1)

#endif // _MSC_VER > 1000

#include "winsock.h"
#include "LinePlot.h"
#include <math.h>
#include "TCPServer.h"

/////////////////////////////////////////////////////////////////////////////
// CTCPClientDlg dialog

class CTCPClientDlg : public CDialog
{
// Construction
public:
	CTCPClientDlg(CWnd* pParent = NULL);	// standard constructor
    ~CTCPClientDlg();
// Dialog Data
	//{{AFX_DATA(CTCPClientDlg)
	enum { IDD = IDD_TCPCLIENT_DIALOG };
	CButton	m_Version;
	CButton	m_Reflectance;
	CButton	m_Optimize;
	CButton	m_Normalize;
	CButton	m_EndingWavelength;
	CButton	m_StartingWavelength;
	CButton	m_DarkCorrectedSpectrum;
	CButton	m_Acquire;
	CButton	m_Disconnect;
	CButton	m_Connect;
	CListBox	m_Header;
	CLinePlot m_LinePlot;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTCPClientDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;
	WSADATA WsaDat;
	SOCKET Socket;
    int m_iStartingWavelength;
	int m_iEndingWavelength;
	int m_iVnirEndingWavelength;
	int m_iSwir1EndingWavelength;
	int m_iSwir2EndingWavelength;
	CString m_sXCaption;
	CString m_sYCaption;
	float m_yMin;
	float m_yMax;
	int m_xInterval;
	int m_yInterval;
	UINT m_xPrecision;
	UINT m_yPrecision;
	bool m_yLock;
	bool m_xLock;

	void ReleaseObjects();
	void SizeControls();
	void InitGraph();
	void PlotData(float *SpecBuffer, int uPoints, CString strKey, COLORREF crColor);
	void WaitForIOEvent(int bytesRecv, unsigned char *recvBuf, int *totalBytesRec);
	double swapWord(double dNumber);
	void GetFlashValue(ParamStruct *ps, CString strCommand);
	void OptimizeInstrument(OptimizeStruct *os, CString strCommand);
	void DisplayDarkCorrectedSpectrum();
	void Acquire(FRSpecStruct *iss, CString strCommand);
	void ConvertToFloat(FRSpecStruct *iss);
	void InstrumentControl(InstrumentControlStruct *ics, CString strCommand);

	// Generated message map functions
	//{{AFX_MSG(CTCPClientDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnAcquire();
	afx_msg void OnConnect();
	afx_msg void OnDarkCorrectedSpectrum();
	afx_msg void OnDisconnect();
	afx_msg void OnGetEndingWavelength();
	afx_msg void OnGetStartingWavelength();
	afx_msg void OnNormalizeSpectrum();
	afx_msg void OnOptimize();
	afx_msg void OnReflectance();
	afx_msg void OnVersion();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TCPCLIENTDLG_H__AA074DEF_1977_45EA_A9A5_FA98CBE8BB5C__INCLUDED_)
