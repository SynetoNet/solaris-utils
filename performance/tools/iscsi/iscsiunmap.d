#!/usr/sbin/dtrace -qs

dtrace:::BEGIN
{
        printf("Tracing STMF UNMAP commands.\n\n");
        bytes_sbd_handle_unmap_xfer = 0;
}

fbt:stmf_sbd:sbd_unmap:entry
{
        start_sbd_unmap = timestamp;
        bytes_sbd_handle_unmap_xfer += arg2;
        printf("    -> UNMAP offset=%x; len=%d\n", arg1, arg2);
}

fbt:stmf_sbd:sbd_handle_unmap_xfer:entry
{
        start_sbd_handle_unmap_xfer = timestamp;
        bytes_sbd_handle_unmap_xfer = 0;
        printf("UNMAP starting ...\n");
}

fbt:stmf_sbd:sbd_handle_unmap_xfer:return
/start_sbd_handle_unmap_xfer > 0/
{
        printf("UNMAP took %d ms to free %d MB\n", (timestamp - start_sbd_handle_unmap_xfer)/1000/1000, bytes_sbd_handle_unmap_xfer / 1024 / 1024);
}
