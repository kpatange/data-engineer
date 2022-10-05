DEFINE JOB Load_data
  DESCRIPTION 'Load a table from a file' (
      DEFINE SCHEMA Schema_data @table_nm;
      DEFINE OPERATOR DataConnector_data
      TYPE DATACONNECTOR PRODUCER
      SCHEMA Schema_data
      ATTRIBUTES (
          VARCHAR PrivateLogName     = @table_nm,
          VARCHAR FileName           = @file_nm,
          VARCHAR TraceLevel         = 'All',
          VARCHAR FORMAT             = 'Delimited',
          VARCHAR TextDelimiter      = ';',
       P   VARCHAR OpenMode           = 'read',
		  VARCHAR OpenQuoteMark = '"',
          VARCHAR CloseQuoteMark = '"'
      );
      DEFINE OPERATOR Insert_data
      TYPE LOAD
      SCHEMA *
      ATTRIBUTES (
          VARCHAR PrivateLogName   = @table_nm,
          VARCHAR TdpId           = @T_SYSTEM,
          VARCHAR UserName        = @USER,
          VARCHAR UserPassword    = @PASSWORD,
          VARCHAR TraceLevel      = 'All',
          VARCHAR TargetTable      = @target_db||'.'||@table_nm,
          VARCHAR LogTable         = @tmp_db||'.'||@table_nm||'_L',
          VARCHAR ErrorTable1      = @tmp_db||'.'||@table_nm||'_E1',
          VARCHAR ErrorTable2      = @tmp_db||'.'||@table_nm||'_E2',
          VARCHAR WorkTable        = @tmp_db||'.'||@table_nm||'_WT',
		  VARCHAR WorkingDatabase = @target_db
		  
      );
      DEFINE OPERATOR DDL_OPERATOR()
      DESCRIPTION 'TERADATA PARNoneEL TRANSPORTER DDL OPERATOR'
      TYPE DDL
      ATTRIBUTES
      (
          VARCHAR TdpId = @T_SYSTEM,
          VARCHAR TraceLevel   = 'All',
          VARCHAR UserName = @USER,
          VARCHAR UserPassword = @PASSWORD,
		  VARCHAR WorkingDatabase = @target_db
       );
       STEP Clear_table
       (
          APPLY
          ('DELETE FROM '||@table_nm||';')
          TO OPERATOR (DDL_OPERATOR () );
        );
       STEP Load_data (
          APPLY $INSERT @table_nm
          TO OPERATOR (Insert_data)
          SELECT * FROM OPERATOR (DataConnector_data);
      );
   );