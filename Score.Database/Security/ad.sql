﻿CREATE SCHEMA [ad]
    AUTHORIZATION [dbo];


GO
GRANT UPDATE
    ON SCHEMA::[ad] TO [adUpdate];


GO
GRANT INSERT
    ON SCHEMA::[ad] TO [adUpdate];


GO
GRANT EXECUTE
    ON SCHEMA::[ad] TO [adUpdate];


GO
GRANT DELETE
    ON SCHEMA::[ad] TO [adUpdate];


GO
GRANT SELECT
    ON SCHEMA::[ad] TO [adRead];

