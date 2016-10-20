
#ifndef _TCPSERVER_H_
#define _TCPSERVER_H_
//
// Return Header values.
//
#define H_NO_ERROR					(100)
#define H_COLLECT_ERROR				(200)
#define H_COLLECT_NOT_LOADED		(300)
#define H_INIT_ERROR				(400)
#define H_FLASH_ERROR				(500)
#define H_RESET_ERROR				(600)
#define H_INTERPOLATE_ERROR			(700)
#define H_OPTIMIZE_ERROR			(800)
#define H_INSTRUMENT_CONTROL_ERROR	(900)
//
// Return error codes.
//
#define NO_ERROR_			(0)
#define NOT_READY			(-1)
#define NO_INDEX_MARKS		(-2)
#define TOO_MANY_ZEROS		(-3)
#define SCANSIZE_ERROR		(-4)
#define INPROCESS_OVERFLOW	(-5)
#define COMMAND_ERROR		(-6)
#define INI_FULL			(-7)
#define MISSING_PARAMETER	(-8)
#define INTERP_ERROR		(-9)
#define VNIR_TIMEOUT		(-10)
#define SWIR_TIMEOUT		(-11)
#define VNIR_NOT_READY		(-12)
#define SWIR1_NOT_READY		(-13)
#define SWIR2_NOT_READY		(-14)
#define VNIR_OPT_ERROR		(-15)
#define SWIR1_OPT_ERROR		(-16)
#define SWIR2_OPT_ERROR		(-17)
#define ABORT_ERROR			(-18)
#define PARAM_ERROR			(-19)
//
// 
//
#define MAX_PARAMETERS		(200)
//
// Detector Index Value
//
#define SWIR1  (0)
#define SWIR2  (1)
#define VNIR   (2)
//
// Instrument Control values
//
#define IC_IT		(0)
#define IC_GAIN		(1)
#define IC_OFFSET	(2)
#define IC_SHUTTER	(3)
//
// Union used to swap word to make double value
//
union dv 
{
	double d; 
	unsigned long l[sizeof(double)/sizeof(long)];
	unsigned char c[sizeof(double)];
}; 
//
// Vnir Header section
//
struct Vnir_Header
{
	int IT;
    int sample_count;
    int max_channel;
    int min_channel;
    int saturation;
    int shutter;
    int reserved[10];
};
//
// Swir Header section
//
struct Swir_Header
{
	int tec_status;
	int tec_current; 
	int max_channel;
	int min_channel;
	int saturation;
	int A_Scans;
	int B_Scans;
	int dark_current;
	int gain;
	int offset;
	int reserved[6];  
};
//
// return Spectrum Header
//
struct SpectrumHeader 
{
	int Header;
	int errbyte;
	int sample_count;
	int trigger;
	int voltage;
	int current;
	int temperature;
	int motor_current;
	int instrument_hours;
	int instrument_minutes;
	int reserved[6];
	Vnir_Header v_header;
	Swir_Header s1_header;
	Swir_Header s2_header;
};
//
//  Acquire structure to return for Full Range Spectrometers
//
struct FRSpecStruct
{
   	SpectrumHeader FRHeader;  
	union 
	{
		float f;
		int i;
	}SpecBuffer[2151];
};

//
//  Acquire structure to return for Vnir Spectrometers
//
struct VSpecStruct
{
    SpectrumHeader VHeader;
    union 
	{
		float f;
		int i;
	}SpecBuffer [701];
};
//
//  Acquire structure to return for Swir1 Swir2 Spectrometers
//
struct S1S2SpecStruct
{
    SpectrumHeader S1S2Header;
    union 
	{
		float f;
		int i;
	}SpecBuffer [1502];
};
//
//  Acquire structure to return for Swir1 Spectrometers
//
struct S1SpecStruct
{
    SpectrumHeader S1SpectrumHeader;
    union 
	{
		float f;
		int i;
	}SpecBuffer [801];
};
//
//  Acquire structure to return for Swir2 Spectrometers
//
struct S2SpecStruct
{
    SpectrumHeader S2Header;
    union 
	{
		float f;
		int i;
	}SpecBuffer [701];
};
//
//  Acquire structure to return for Vnir/Swir1 Spectrometers
//
struct VS1SpecStruct
{
    SpectrumHeader VS1Header; 
    union 
	{
		float f;
		int i;
	}SpecBuffer [1502];
};
//
//  Acquire structure to return for Vnir/Swir2 Spectrometers
//
struct VS2SpecStruct
{
    SpectrumHeader VS2Header;
    union 
	{
		float f;
		int i;
	}SpecBuffer [1402];
};
// 
// Ini struct for the flash
//
struct InitStruct
{
    int Header;                     //header type used in TCP transfer.
    int errbyte;                    //error code 
    char name [MAX_PARAMETERS][30]; //space for 200 entries with 30 character names
    double value [MAX_PARAMETERS];  //corresponding data values for the 200 entries
    int count;                      //The number of used entries
    int verify;                     //the checksum 
};
//
// Version structure for V Command
//
struct VersionStruct
{
    int Header;         //header type used in TCP transfer.
    int errbyte;        //error code 
    char version[30];	//30 character version string
    double value;       //version value
    int reserved;       //not used
};
// 
// Optimize structure for OPT command
//
struct OptimizeStruct
{
	int Header;             //header type used in TCP transfer.
    int errbyte;            //error code
    int itime;              //optimized integration time
    int gain[2];            //optimized gain for 2 SWIRs
    int offset[2];          //optimized offset for 2 SWIRs
};
//
// Param structure for INIT command
// 
struct ParamStruct
{
    int Header;             //header type used in TCP transfer.
    int errbyte;            //error code 
    char name [30];         //30 character name
    double value;           //corresponding data values
    int count;              //number of entries used
};
//
// Instrument Control Structure for IC command
//
struct InstrumentControlStruct
{
    int Header;				//header type used in TCP transfer.
    int errbyte;			//error code
    int detector;			//detector value - IC_IT,IC_GAIN,IC_OFFSET,IC_SHUTTER
   	int cmdType;			//detector command 
    int value;				//command value
};
	
#endif
