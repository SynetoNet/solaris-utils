#!/usr/sbin/dtrace -Cs

fbt:zfs:zil_commit:entry
{
    self->zilog = (zilog_t *) arg0;
    self->spa = self->zilog->zl_spa;
    self->zil_ts = timestamp;
}

fbt:zfs:zil_commit:return
{
    self->zil_ctime = (timestamp - self->zil_ts) / 1000000;
    @[self->spa->spa_name] = quantize(self->zil_ctime);
    self->zilog = 0;
    self->spa = 0;
    self->zil_ts = 0;
    self->zil_ctime = 0;
}

tick-5sec
{
    printa(@);
}

