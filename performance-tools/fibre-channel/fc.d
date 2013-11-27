#!/usr/sbin/dtrace -s

#pragma D option quiet

dtrace:::BEGIN
{
	printf("Tracing... Hit Ctrl-C to end.\n");
	@transfer = sum(0);
}

fc:::xfer-start
{
	@transfer = sum(args[4]->fcx_len);
/* quantize(args[4]->fcx_len);
*/
}

profile:::tick-1sec
{
	printa(@transfer);
}
