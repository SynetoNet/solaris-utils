#!/usr/sbin/dtrace -s
/*
 * Count FC IOPS per client.
 */
#pragma D option quiet

dtrace:::BEGIN
{
	printf("Tracing... Hit Ctrl-C to end.\n");
}

fc:::xfer-start
{
	@[args[0]->ci_remote] = count();
}

profile:::tick-1sec
{
	printa(@);
	trunc(@);
}
