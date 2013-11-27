#!/usr/sbin/dtrace -s
/*
 * FC Transfer rate
 */
#pragma D option quiet

dtrace:::BEGIN
{
	printf("Tracing... Hit Ctrl-C to end.\n");
}

fc:::xfer-start
{
	@[args[0]->ci_remote] = sum(args[4]->fcx_len / 1024 / 1024);
}

profile:::tick-1sec
{
	printa(@);
	trunc(@);
}
