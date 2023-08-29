// fb neo m37710 / m37702 cpu intf

#include "m377/m37710.h"

void M377Init(INT32 cpunum);
void M377Exit();
void M377Open(INT32 cpunum);
void M377Close();
INT32 M377Scan(INT32 nAction);

void M377SetWritePortHandler(void (*write)(UINT32,UINT8));
void M377SetReadPortHandler(UINT8  (*read)(UINT32));
void M377SetWriteByteHandler(void (*write)(UINT32,UINT8));
void M377SetWriteWordHandler(void (*write)(UINT32,UINT16));
void M377SetReadByteHandler(UINT8  (*read)(UINT32));
void M377SetReadWordHandler(UINT16 (*read)(UINT32));
void M377MapMemory(UINT8 *ptr, UINT64 start, UINT64 end, UINT32 flags);

void M377Reset();
void M377NewFrame();
INT32 M377TotalCycles();
INT32 M377Run(INT32 cycles);
INT32 M377Idle(INT32 cycles);
void M377RunEnd();
void M377SetIRQLine(INT32 inputnum, INT32 state);
INT32 M377GetActive();

void M377WriteWord(UINT32 address, UINT16 data);
void M377WriteByte(UINT32 address, UINT8 data);
UINT16 M377ReadWord(UINT32 address);
UINT8 M377ReadByte(UINT32 address);

extern struct cpu_core_config M377Config;

#define BurnTimerAttachM377(clock)	\
	BurnTimerAttach(&M377Config, clock)
