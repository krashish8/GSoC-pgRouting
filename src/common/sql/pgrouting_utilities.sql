/*
  0: debuging   raise debug
  1: report     raise notice
  2: abort excecution  
*/

CREATE OR REPLACE FUNCTION pgr_onError(IN err boolean,IN action int, IN functionname text, IN msgerr text, IN hinto text default NULL,IN msgok text default 'OK' )
  RETURNS void AS
$BODY$
BEGIN
  if err=true then 
     if action=0 then
       raise debug '----> PGR ERROR in %: %',functionname,msgerr USING HINT = '  ---->'|| hinto;
     else 
       if action = 2 then
         raise notice '----> PGR ERROR in %: %',functionname,msgerr USING HINT = '  ---->'|| hinto;
         raise raise_exception;
       else
         raise notice '----> PGR ERROR in %: %',functionname,msgerr USING HINT = '  ---->'|| hinto;
       end if;
     end if;
  else
       raise debug 'PGR ----> %: %',functionname,msgok;
  end if;
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_onError(boolean,int,text,text,text,text) IS 'args: err,action,functionname,msgerr,hinto=NULL, msgOK=OK,  -raises the error message and hint message at different levels';
   




-- -------------------------------------------------------------------
-- pgrouting_utilities.sql
-- AuthorL Stephen Woodbridge <woodbri@imaptools.com>
-- Copyright 2013 Stephen Woodbridge
-- This file is release unde an MIT-X license.
-- -------------------------------------------------------------------


/*
.. function:: pgr_getTableName(tab)
   
   Examples:  
	* 	 select * from  pgr_getTableName('tab');
        *        naming record;
		 excecute 'select * from  pgr_getTableName('||quote_literal(tab)||')' INTO naming;
	         schema=naming.sname; table=naming.tname
		   

   Returns (schema,name) of table "tab" considers Caps and when not found considers lowercases
           (schema,NULL) when table was not found 
           (NULL,NULL) when schema was not found. 

   Author: Vicky Vergara <vicky_vergara@hotmail.com>>

  HISTORY
     Created: 2013/08/19  for handling schemas

*/
CREATE OR REPLACE FUNCTION pgr_getTableName(IN tab text, IN reportErrs int default 1, OUT sname text,OUT tname text)
  RETURNS RECORD AS
$BODY$ 
DECLARE
	naming record;
	i integer;
	query text;
        sn text;
        tn text;
        err boolean;
	debuglevel text;
BEGIN

    execute 'show client_min_messages' into debuglevel;


    RAISE DEBUG 'Cheking % exists',tab;

    execute 'select strpos('||quote_literal(tab)||','||quote_literal('.')||')' into i;
    if (i!=0) then 
	execute 'select substr('||quote_literal(tab)||',1,strpos('||quote_literal(tab)||','||quote_literal('.')||')-1)' into sn;
	execute 'select substr('||quote_literal(tab)||',strpos('||quote_literal(tab)||','||quote_literal('.')||')+1),length('||quote_literal(tab)||')' into tn;
    else 
        execute 'select current_schema' into sn;
        tn =tab;
    end if;
    
    
    EXECUTE 'SELECT schema_name FROM information_schema.schemata WHERE schema_name = '||quote_literal(sn) into naming;
    sname=naming.schema_name;
    
    if sname is NOT NULL THEN -- found schema (as is)
    	EXECUTE 'select table_name from information_schema.tables where 
		table_type='||quote_literal('BASE TABLE')||' and 
		table_schema='||quote_literal(sname)||' and 
		table_name='||quote_literal(tn) INTO  naming;
	tname=naming.table_name;	
	IF tname is NULL THEN
	   EXECUTE 'select table_name from information_schema.tables where 
		table_type='||quote_literal('BASE TABLE')||' and 
		table_schema='||quote_literal(sname)||' and 
		table_name='||quote_literal(lower(tn))||'order by table_name' INTO naming;
	   tname=naming.table_name;		
	END IF;
    END IF;	 
    IF sname is NULL or tname is NULL THEN 	--schema not found or table in schema was not found        	
	EXECUTE 'SELECT schema_name FROM information_schema.schemata WHERE schema_name = '||quote_literal(lower(sn)) into naming;
	sname=naming.schema_name;
	if sname is NOT NULL THEN -- found schema (with lower caps)	
	   EXECUTE 'select table_name from information_schema.tables where 
		table_type='||quote_literal('BASE TABLE')||' and 
		table_schema='||quote_literal(sname)||' and 
		table_name='||quote_literal(tn) INTO  naming;
	   tname=naming.table_name;	
	   IF tname is NULL THEN
		EXECUTE 'select table_name from information_schema.tables where 
			table_type='||quote_literal('BASE TABLE')||' and 
			table_schema='||quote_literal(sname)||' and 
			table_name='||quote_literal(lower(tn))||'order by table_name' INTO naming;
		tname=naming.table_name;		
	   END IF;
	END IF;
    END IF;	   
   err= case when sname IS NULL OR tname IS NULL then true else false end; 
   perform pgr_onError(err, reportErrs, 'pgr_getTableName', 'Table ' || tab ||' not found',' Check your table name', 'Table '|| tab || ' found');
	        	
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_getTableName(text,int) IS 'args: tab,reportErrs=1  -gets the schema (sname) and the table (tname) form the table tab';


/*
.. function:: pgr_getColumnName(tab,col)
   
   Examples:  
	* 	 select  pgr_getColumnName('tab','col');
        *        column text;
		 excecute 'select pgr_getColumnName('||quote_literal('tab')||','||quote_literal('col')||')' INTO column;


   Returns cname of column "col" in table "tab" considers Caps and when not found considers lowercases
           NULL when "tab" is not found or when "col" is not in table "tab"

   Author: Vicky Vergara <vicky_vergara@hotmail.com>>

  HISTORY
     Created: 2013/08/19  for handling schemas
*/



CREATE OR REPLACE FUNCTION pgr_getColumnName(sname text, tname text, col text, IN reportErrs int default 1)
RETURNS text AS
$BODY$
DECLARE
    cname text;
    naming record;
    err boolean;
BEGIN

    execute 'SELECT column_name FROM information_schema.columns
          WHERE table_name='||quote_literal(tname)||' and table_schema='||quote_literal(sname)||' and column_name='||quote_literal(col) into cname;

    IF cname is null  THEN
            execute 'SELECT column_name FROM information_schema.columns
            WHERE table_name='||quote_literal(tname)||' and table_schema='||quote_literal(sname)||' and column_name='||quote_literal(lower(col)) into cname;
    END if;

    err=cname is null;

    perform pgr_onError(err, reportErrs, 'pgr_getColumnName',  'Column '|| col ||' not found', ' Check your column name','Column '|| col || ' found');
    RETURN cname;
END;

$BODY$
LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_getColumnName(text,text,text,int) IS 'args: sname,tname,col -gets the rregistered column name of "col" in table "sname.tname"';



CREATE OR REPLACE FUNCTION pgr_getColumnName(tab text, col text, IN reportErrs int default 1)
RETURNS text AS
$BODY$
DECLARE
    sname text;
    tname text;
    cname text;
    naming record;
    err boolean;
BEGIN
    select * into naming from pgr_getTableName(tab,reportErrs) ;
    sname=naming.sname;
    tname=naming.tname;
   
    select * into cname from pgr_getColumnName(sname,tname,col,reportErrs);
    RETURN cname;
END;

$BODY$
LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_getColumnName(text,text,int) IS 'args: tab,col -gets the registered column name of "col" in table "tab"';

/*
*/
CREATE OR REPLACE FUNCTION pgr_checkVertTab(vertname text, columns  text[], reporterrs integer default 1,OUT sname text,OUT vname text)
RETURNS record AS
$BODY$
DECLARE
    cname text;
    colname text;
    naming record;
    debuglevel text;
    err boolean;
--checking vertices table

BEGIN
   execute 'show client_min_messages' into debuglevel;


    BEGIN
       raise DEBUG 'Checking table % exists ',vertname;
       execute 'select * from pgr_getTableName('||quote_literal(vertname)||',2)' into naming;
       sname=naming.sname;
       vname=naming.tname;
       EXCEPTION WHEN raise_exception THEN
           raise notice '   --->Please create % using pgr_createTopology() or pgr_createVerticesTable()',vertname;
    END;

   FOREACH cname IN ARRAY columns loop
      raise debug 'checking ---> %',cname;
       execute 'select pgr_getcolumnName('||quote_literal(vertname)||','||quote_literal(cname)||',0)' into colname;
       if colname is null     then
         RAISE debug '  ------>Adding % column in %',cname,vertname;
         set client_min_messages  to warning;
                execute 'ALTER TABLE '||pgr_quote_ident(vertname)||' ADD COLUMN '||cname|| ' integer';
         execute 'set client_min_messages  to '|| debuglevel;
        end if;
  end loop;
  perform pgr_createIndex(vertname , 'id' , 'btree');

 END
$BODY$
LANGUAGE plpgsql VOLATILE STRICT;





/*
*/
CREATE OR REPLACE FUNCTION pgr_getColumnType(sname text, tname text, cname text, IN reportErrs int default 1)
RETURNS text AS
$BODY$
DECLARE
    ctype text;
    naming record;
    err boolean;
BEGIN

    EXECUTE 'select data_type  from information_schema.columns where table_name = '||quote_literal(tname)||
                        ' and table_schema='||quote_literal(sname)||' and column_name='||quote_literal(cname) into ctype;
    err=ctype is null;
    perform pgr_onError(err, reportErrs, 'pgr_getColumnType',  'Type of Column '|| cname ||' not found', ' Check your column name','Type of Column '|| cname || ' is ' || ctype);
    RETURN ctype;
END;

$BODY$
LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_getColumnType(text,text,text,int) IS 'args: sname,tname,cname -gets the type of the column  "col" in table "sname.tname"';


CREATE OR REPLACE FUNCTION pgr_getColumnType(tab text, col text, IN reportErrs int default 1)
RETURNS text AS
$BODY$
DECLARE
    sname text;
    tname text;
    cname text;
    ctype text;
    naming record;
    err boolean;
BEGIN
  
    select * into naming from pgr_getTableName(tab,reportErrs) ;
    sname=naming.sname;
    tname=naming.tname;
    select * into cname from pgr_getColumnName(tab,col,reportErrs) ;
    select * into ctype from pgr_getColumnType(sname,tname,cname,reportErrs);
    RETURN ctype;
END;

$BODY$
LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_getColumnType(text,text,int) IS 'args: tab,col -gets the type of column name of "col" in table "tab"';




/*
.. function:: pgr_isColumnInTable(tab, col)

   Examples:  
	* 	 select  pgr_isColumnName('tab','col');
        *        flag boolean;
		 excecute 'select pgr_getColumnName('||quote_literal('tab')||','||quote_literal('col')||')' INTO flag;

   Returns true  if column "col" exists in table "tab"
           false when "tab" doesn't exist or when "col" is not in table "tab"

   Author: Stephen Woodbridge <woodbri@imaptools.com>

   Modified by: Vicky Vergara <vicky_vergara@hotmail.com>>

  HISTORY
     Modified: 2013/08/19  for handling schemas
*/
CREATE OR REPLACE FUNCTION pgr_isColumnInTable(tab text, col text)
RETURNS boolean AS
$BODY$
DECLARE
    cname text;
BEGIN
    select * from pgr_getColumnName(tab,col,0) into cname;
  
    IF cname IS NULL THEN
        RETURN false;
    ELSE
        RETURN true;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_isColumnInTable(text,text) IS 'args: tab,col  -returns true when the column "col" is in table "tab"';


/*
.. function:: pgr_isColumnIndexed(tab, col)

   Examples:  
	* 	 select  pgr_isColumnIndexed('tab','col');
        *        flag boolean;
		 excecute 'select pgr_getColumnIndexed('||quote_literal('tab')||','||quote_literal('col')||')' INTO flag;

   Author: Stephen Woodbridge <woodbri@imaptools.com>

   Modified by: Vicky Vergara <vicky_vergara@hotmail.com>>

   Returns true  when column "col" in table "tab" is indexed.
           false when table "tab"  is not found or 
                 when column "col" is nor found in table "tab" or
	  	 when column "col" is not indexed

*/
CREATE OR REPLACE FUNCTION public.pgr_isColumnIndexed(tab text, col text)
RETURNS boolean AS
$BODY$
DECLARE
    naming record;
    rec record;
    sname text;
    tname text;
    cname text;
    pkey text;
BEGIN
    SELECT * into naming FROM pgr_getTableName(tab);
    sname=naming.sname;
    tname=naming.tname;
    IF sname IS NULL OR tname IS NULL THEN
	RETURN FALSE;
    END IF;
    SELECT pgr_getColumnName(tab,col) INTO cname;
    IF cname IS NULL THEN
	RETURN FALSE;
    END IF;
    SELECT               
          pg_attribute.attname into pkey
         --  format_type(pg_attribute.atttypid, pg_attribute.atttypmod) 
          FROM pg_index, pg_class, pg_attribute 
          WHERE 
                  pg_class.oid = pgr_quote_ident(sname||'.'||tname)::regclass AND
                  indrelid = pg_class.oid AND
                  pg_attribute.attrelid = pg_class.oid AND 
                  pg_attribute.attnum = any(pg_index.indkey)
                  AND indisprimary;
        
    IF pkey=cname then
          RETURN TRUE; 
    END IF;
                      

   
    SELECT a.index_name, 
           b.attname,
           b.attnum,
           a.indisunique,
           a.indisprimary
      INTO rec
      FROM ( SELECT a.indrelid,
                    a.indisunique,
                    a.indisprimary, 
                    c.relname index_name, 
                    unnest(a.indkey) index_num 
               FROM pg_index a,
                    pg_class b, 
                    pg_class c,
                    pg_namespace d  
              WHERE b.relname=tname
                AND b.relnamespace=d.oid
                AND d.nspname=sname 
                AND b.oid=a.indrelid 
                AND a.indexrelid=c.oid 
           ) a, 
           pg_attribute b 
     WHERE a.indrelid = b.attrelid 
       AND a.index_num = b.attnum 
       AND b.attname = cname
  ORDER BY a.index_name, 
           a.index_num;

    IF FOUND THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT;
COMMENT ON FUNCTION pgr_isColumnIndexed(text,text) IS 'args: tab,col  -returns true if column "col" in table "tab" is indexed';


CREATE OR REPLACE FUNCTION pgr_createIndex(tabname text, colname text, indextype text)
RETURNS void AS
$BODY$
DECLARE
    debuglevel text;
    naming record;
    sname text;
    tname text;

BEGIN
    execute 'show client_min_messages' into debuglevel;
    execute 'select * from pgr_getTableName('||quote_literal(tabname)||',0)' into naming;
    sname=naming.sname;
    tname=naming.tname;
    RAISE DEBUG 'Cheking "%" column in % is indexed',colname,tabname;
    IF (pgr_isColumnIndexed(tabname,colname)) then
          RAISE DEBUG ' ------>OK';
    else
      RAISE DEBUG ' ------> Adding  index "%_%_idx".',tabname,colname;
      set client_min_messages  to warning;
      if indextype = 'btree' then 
          execute 'create  index '||pgr_quote_ident(tname||'_'||colname||'_idx')||' 
                         on '||pgr_quote_ident(tabname)||' using btree('||quote_ident(colname)||')';
      else 
          execute 'create  index '||pgr_quote_ident(tname||'_'||colname||'_gidx')||' 
                         on '||pgr_quote_ident(tabname)||' using gist ('||quote_ident(colname)||')';
      end if;
          execute 'set client_min_messages  to ' ||debuglevel;
    END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE STRICT;
--COMMENT ON FUNCTION pgr_isColumnInTable(text,text) IS 'args: tab,col  -returns true when the column "col" is in table "tab"';




create or replace function pgr_quote_ident(idname text)
    returns text as
$body$
/*
.. function:: pgr_quote_ident(text)

   Author: Stephen Woodbridge <woodbri@imaptools.com>

   Function to split a string on '.' characters and then quote the 
   components as postgres identifiers and then join them back together
   with '.' characters. multile '.' will get collapsed into a single
   '.' so 'schema...table' till get returned as 'schema."table"' and 
   'Schema.table' becomes '"Schema'.'table"'

*/

declare
    t text[];
    pgver text;

begin
    pgver := regexp_replace(version(), E'^PostgreSQL ([^ ]+)[ ,].*$', E'\\1');

/*
    RAISE NOTICE 'pgr_quote_ident(%), pgver: %, version: %, versionless %',
        tab, pgver, version(), pgr_versionless(pgver, '9.2');
*/

    if pgr_versionless(pgver, '9.2') then
        select into t array_agg(quote_ident(term)) from
            (select nullif(unnest, '') as term
               from unnest(string_to_array(idname, '.'))) as foo;
    else
        select into t array_agg(quote_ident(term)) from
            (select unnest(string_to_array(idname, '.', '')) as term) as foo;
    end if;
    return array_to_string(t, '.');
end;
$body$
language plpgsql immutable;
COMMENT ON function pgr_quote_ident(text) IS 'args: idname  -  quote_ident to all parts of the identifier "idname"';


CREATE OR REPLACE FUNCTION pgr_versionless(v1 text, v2 text)
  RETURNS boolean AS
$BODY$
/*
 * function for comparing version strings.
 * Ex: select pgr_version_less(postgis_lib_version(), '2.1');

   Author: Stephen Woodbridge <woodbri@imaptools.com>
 *
 * needed because postgis 2.1 deprecates some function names and
 * we need to detect the version at runtime
*/

declare
    v1a text[];
    v2a text[];
    nv1 integer;
    nv2 integer;
    ne1 integer;
    ne2 integer;
    
begin
    -- separate components into an array, like:
    -- '2.1.0-beta3dev'  =>  {2,1,0,beta3dev}
    v1a := regexp_matches(v1, E'^(\\d+)(?:[\\.](\\d+))?(?:[\\.](\\d+))?[-+\\.]?(.*)$');
    v2a := regexp_matches(v2, E'^(\\d+)(?:[\\.](\\d+))?(?:[\\.](\\d+))?[-+\\.]?(.*)$');

    -- convert modifiers to numbers for comparison
    -- we do not delineate between alpha1, alpha2, alpha3, etc
    ne1 := case when v1a[4] is null or v1a[4]='' then 5
                when v1a[4] ilike 'rc%' then 4
                when v1a[4] ilike 'beta%' then 3
                when v1a[4] ilike 'alpha%' then 2
                when v1a[4] ilike 'dev%' then 1
                else 0 end;

    ne2 := case when v2a[4] is null or v2a[4]='' then 5
                when v2a[4] ilike 'rc%' then 4
                when v2a[4] ilike 'beta%' then 3
                when v2a[4] ilike 'alpha%' then 2
                when v2a[4] ilike 'dev%' then 1
                else 0 end;

    nv1 := v1a[1]::integer * 10000 +
           coalesce(v1a[2], '0')::integer * 1000 +
           coalesce(v1a[3], '0')::integer *  100 + ne1;
    nv2 := v2a[1]::integer * 10000 + 
           coalesce(v2a[2], '0')::integer * 1000 + 
           coalesce(v2a[3], '0')::integer *  100 + ne2;

    --raise notice 'nv1: %, nv2: %, ne1: %, ne2: %', nv1, nv2, ne1, ne2;

    return nv1 < nv2;
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 1;
COMMENT ON function pgr_versionless(text,text) IS 'args: v1,v2  - returns true when v1 < v2';


create or replace function pgr_startPoint(g geometry)
    returns geometry as
$body$
declare

begin
    if geometrytype(g) ~ '^MULTI' then
        return st_startpoint(st_geometryn(g,1));
    else
        return st_startpoint(g);
    end if;
end;
$body$
language plpgsql IMMUTABLE;
COMMENT ON function pgr_startPoint(geometry) IS 'args: g  - returns start point of the geometry "g" even if its multi';



create or replace function pgr_endPoint(g geometry)
    returns geometry as
$body$
declare

begin
    if geometrytype(g) ~ '^MULTI' then
        return st_endpoint(st_geometryn(g,1));
    else
        return st_endpoint(g);
    end if;
end;
$body$
language plpgsql IMMUTABLE;
COMMENT ON function pgr_endPoint(geometry) IS 'args: g  - returns end point of the geometry "g" even if its multi';

