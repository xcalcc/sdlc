FROM postgres:10-alpine

COPY workdir/src/main/resources/sql_script/*.sql /docker-entrypoint-initdb.d/
COPY workdir/src/main/resources/sql_script/rule_set/rule_standard/*.sql /docker-entrypoint-initdb.d/
COPY workdir/src/main/resources/sql_script/rule_set/xcalibyte_builtin/*.sql /docker-entrypoint-initdb.d/
COPY workdir/src/main/resources/sql_script/rule_set/xcalibyte_cert/*.sql /docker-entrypoint-initdb.d/
COPY workdir/src/main/resources/sql_script/rule_set/xcalibyte_custom/001031_engine_xcalibyte_ruleset_builtin_custom_uisee.sql /docker-entrypoint-initdb.d/
COPY workdir/src/main/resources/sql_script/rule_set/xcalibyte_custom/001031_engine_xcalibyte_ruleset_builtin_custom.sql /docker-entrypoint-initdb.d/

COPY ./VER /VER
