
CREATE TABLE [CUSTOMER]
( 
	[CustomerID]         integer  NOT NULL ,
	[CustomerAdress]     varchar(50)  NULL ,
	[Email]              varchar(50)  NULL ,
	[CustomerCity]       varchar(50)  NULL ,
	[CustomerFirstName]  varchar(20)  NULL ,
	[CustomerLastName]   varchar(20)  NULL ,
	[CustomerZipCode]    integer  NULL ,
	[CustomerState]      char(2)  NULL 
)
go

CREATE TABLE [CUSTOMER_CREDIT]
( 
	[CreditId]           integer  NOT NULL ,
	[CreditCardNumber]   integer  NULL ,
	[CVV]                integer  NULL ,
	[CustomerID]         integer  NOT NULL ,
	[CreditCardExpire]   integer  NULL 
)
go

CREATE TABLE [MOVIE]
( 
	[MovieTitle]         varchar(35)  NULL ,
	[MovieDirector]      varchar(35)  NULL ,
	[MovieDescription]   varchar(100)  NULL ,
	[Rating]             varchar  NULL ,
	[Genre]              char(3)  NULL ,
	[ServiceId]          integer  NOT NULL 
)
go

CREATE TABLE [Movie_Rent]
( 
	[MovieId]            char(18)  NOT NULL ,
	[MovieName]          char(18)  NULL ,
	[MoviePrice]         char(18)  NULL ,
	[DateRented]         char(18)  NULL ,
	[RentedDaysAmount]   char(18)  NULL ,
	[ServiceId]          integer  NULL ,
	[CustomerID]         integer  NULL 
)
go

CREATE TABLE [PAYMENT]
( 
	[PaymentId]          integer  NOT NULL ,
	[PaymentStatus]      varchar(10)  NULL ,
	[CreditCardType]     varchar  NULL ,
	[CustomerID]         integer  NULL ,
	[CreditId]           integer  NULL 
)
go

CREATE TABLE [PAYMENT_RECORD]
( 
	[PaymentId]          integer  NOT NULL ,
	[PaymentDate]        date  NULL ,
	[PaymentAmount]      integer  NULL ,
	[PaymentType]        varchar(10  NULL 
)
go

CREATE TABLE [STREAMING_SERVICE]
( 
	[ServiceId]          integer  NOT NULL ,
	[ServiceName]        varchar(50)  NULL ,
	[ServiceCreator]     varchar(50)  NULL ,
	[ServicePrice]       integer  NOT NULL ,
	[CustomerID]         integer  NOT NULL 
)
go

ALTER TABLE [CUSTOMER]
	ADD CONSTRAINT [XPKCUSTOMER] PRIMARY KEY  CLUSTERED ([CustomerID] ASC)
go

ALTER TABLE [CUSTOMER_CREDIT]
	ADD CONSTRAINT [XPKCUSTOMER_CREDIT] PRIMARY KEY  CLUSTERED ([CreditId] ASC,[CustomerID] ASC)
go

ALTER TABLE [MOVIE]
	ADD CONSTRAINT [XPKMOVIE] PRIMARY KEY  CLUSTERED ([ServiceId] ASC)
go

ALTER TABLE [Movie_Rent]
	ADD CONSTRAINT [XPKMovie_Rent] PRIMARY KEY  CLUSTERED ([MovieId] ASC)
go

ALTER TABLE [PAYMENT]
	ADD CONSTRAINT [XPKPAYMENT] PRIMARY KEY  CLUSTERED ([PaymentId] ASC)
go

ALTER TABLE [PAYMENT_RECORD]
	ADD CONSTRAINT [XPKPAYMENT_RECORD] PRIMARY KEY  CLUSTERED ([PaymentId] ASC)
go

ALTER TABLE [STREAMING_SERVICE]
	ADD CONSTRAINT [XPKSTREAMING_SERVICE] PRIMARY KEY  CLUSTERED ([ServiceId] ASC)
go


ALTER TABLE [CUSTOMER_CREDIT]
	ADD CONSTRAINT [FK_Customer_Customer_Credit] FOREIGN KEY ([CustomerID]) REFERENCES [CUSTOMER]([CustomerID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [MOVIE]
	ADD CONSTRAINT [FK_Streaming_Service_Movie] FOREIGN KEY ([ServiceId]) REFERENCES [STREAMING_SERVICE]([ServiceId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Movie_Rent]
	ADD CONSTRAINT [FK_Customer_Movie_Rent] FOREIGN KEY ([CustomerID]) REFERENCES [CUSTOMER]([CustomerID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Movie_Rent]
	ADD CONSTRAINT [FK_Streaming_Service_Movie_Rent] FOREIGN KEY ([ServiceId]) REFERENCES [STREAMING_SERVICE]([ServiceId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [PAYMENT]
	ADD CONSTRAINT [FK_Customer_Payment] FOREIGN KEY ([CustomerID]) REFERENCES [CUSTOMER]([CustomerID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PAYMENT]
	ADD CONSTRAINT [FK_Customer_Credit_Payment] FOREIGN KEY ([CreditId],[CustomerID]) REFERENCES [CUSTOMER_CREDIT]([CreditId],[CustomerID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [PAYMENT_RECORD]
	ADD CONSTRAINT [FK_Payment_Payment_Record] FOREIGN KEY ([PaymentId]) REFERENCES [PAYMENT]([PaymentId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [STREAMING_SERVICE]
	ADD CONSTRAINT [FK_Streaming_Service_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [CUSTOMER]([CustomerID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

CREATE TRIGGER tD_CUSTOMER ON CUSTOMER FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on CUSTOMER */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* CUSTOMER  Movie_Rent on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00042273", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Movie_Rent", FK_COLUMNS="CustomerID" */
    IF EXISTS (
      SELECT * FROM deleted,Movie_Rent
      WHERE
        /*  %JoinFKPK(Movie_Rent,deleted," = "," AND") */
        Movie_Rent.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete CUSTOMER because Movie_Rent exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CUSTOMER  CUSTOMER_CREDIT on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="CUSTOMER_CREDIT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Customer_Credit", FK_COLUMNS="CustomerID" */
    IF EXISTS (
      SELECT * FROM deleted,CUSTOMER_CREDIT
      WHERE
        /*  %JoinFKPK(CUSTOMER_CREDIT,deleted," = "," AND") */
        CUSTOMER_CREDIT.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete CUSTOMER because CUSTOMER_CREDIT exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CUSTOMER  STREAMING_SERVICE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="STREAMING_SERVICE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Customer", FK_COLUMNS="CustomerID" */
    IF EXISTS (
      SELECT * FROM deleted,STREAMING_SERVICE
      WHERE
        /*  %JoinFKPK(STREAMING_SERVICE,deleted," = "," AND") */
        STREAMING_SERVICE.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete CUSTOMER because STREAMING_SERVICE exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CUSTOMER Hi PAYMENT on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="Hi", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Payment", FK_COLUMNS="CustomerID" */
    IF EXISTS (
      SELECT * FROM deleted,PAYMENT
      WHERE
        /*  %JoinFKPK(PAYMENT,deleted," = "," AND") */
        PAYMENT.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete CUSTOMER because PAYMENT exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_CUSTOMER ON CUSTOMER FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on CUSTOMER */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insCustomerID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* CUSTOMER  Movie_Rent on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00048e3b", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Movie_Rent", FK_COLUMNS="CustomerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Movie_Rent
      WHERE
        /*  %JoinFKPK(Movie_Rent,deleted," = "," AND") */
        Movie_Rent.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update CUSTOMER because Movie_Rent exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CUSTOMER  CUSTOMER_CREDIT on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="CUSTOMER_CREDIT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Customer_Credit", FK_COLUMNS="CustomerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,CUSTOMER_CREDIT
      WHERE
        /*  %JoinFKPK(CUSTOMER_CREDIT,deleted," = "," AND") */
        CUSTOMER_CREDIT.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update CUSTOMER because CUSTOMER_CREDIT exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CUSTOMER  STREAMING_SERVICE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="STREAMING_SERVICE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Customer", FK_COLUMNS="CustomerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,STREAMING_SERVICE
      WHERE
        /*  %JoinFKPK(STREAMING_SERVICE,deleted," = "," AND") */
        STREAMING_SERVICE.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update CUSTOMER because STREAMING_SERVICE exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CUSTOMER Hi PAYMENT on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="Hi", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Payment", FK_COLUMNS="CustomerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PAYMENT
      WHERE
        /*  %JoinFKPK(PAYMENT,deleted," = "," AND") */
        PAYMENT.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update CUSTOMER because PAYMENT exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PAYMENT ON PAYMENT FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PAYMENT */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PAYMENT  PAYMENT_RECORD on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003cf63", PARENT_OWNER="", PARENT_TABLE="PAYMENT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT_RECORD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Payment_Payment_Record", FK_COLUMNS="PaymentId" */
    IF EXISTS (
      SELECT * FROM deleted,PAYMENT_RECORD
      WHERE
        /*  %JoinFKPK(PAYMENT_RECORD,deleted," = "," AND") */
        PAYMENT_RECORD.PaymentId = deleted.PaymentId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PAYMENT because PAYMENT_RECORD exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CUSTOMER_CREDIT  PAYMENT on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER_CREDIT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Credit_Payment", FK_COLUMNS="CreditId""CustomerID" */
    IF EXISTS (SELECT * FROM deleted,CUSTOMER_CREDIT
      WHERE
        /* %JoinFKPK(deleted,CUSTOMER_CREDIT," = "," AND") */
        deleted.CreditId = CUSTOMER_CREDIT.CreditId AND
        deleted.CustomerID = CUSTOMER_CREDIT.CustomerID AND
        NOT EXISTS (
          SELECT * FROM PAYMENT
          WHERE
            /* %JoinFKPK(PAYMENT,CUSTOMER_CREDIT," = "," AND") */
            PAYMENT.CreditId = CUSTOMER_CREDIT.CreditId AND
            PAYMENT.CustomerID = CUSTOMER_CREDIT.CustomerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PAYMENT because CUSTOMER_CREDIT exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CUSTOMER Hi PAYMENT on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="Hi", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Payment", FK_COLUMNS="CustomerID" */
    IF EXISTS (SELECT * FROM deleted,CUSTOMER
      WHERE
        /* %JoinFKPK(deleted,CUSTOMER," = "," AND") */
        deleted.CustomerID = CUSTOMER.CustomerID AND
        NOT EXISTS (
          SELECT * FROM PAYMENT
          WHERE
            /* %JoinFKPK(PAYMENT,CUSTOMER," = "," AND") */
            PAYMENT.CustomerID = CUSTOMER.CustomerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PAYMENT because CUSTOMER exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_PAYMENT ON PAYMENT FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PAYMENT */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insPaymentId integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PAYMENT  PAYMENT_RECORD on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00046959", PARENT_OWNER="", PARENT_TABLE="PAYMENT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT_RECORD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Payment_Payment_Record", FK_COLUMNS="PaymentId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(PaymentId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PAYMENT_RECORD
      WHERE
        /*  %JoinFKPK(PAYMENT_RECORD,deleted," = "," AND") */
        PAYMENT_RECORD.PaymentId = deleted.PaymentId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PAYMENT because PAYMENT_RECORD exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CUSTOMER_CREDIT  PAYMENT on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER_CREDIT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Credit_Payment", FK_COLUMNS="CreditId""CustomerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CreditId) OR
    UPDATE(CustomerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,CUSTOMER_CREDIT
        WHERE
          /* %JoinFKPK(inserted,CUSTOMER_CREDIT) */
          inserted.CreditId = CUSTOMER_CREDIT.CreditId and
          inserted.CustomerID = CUSTOMER_CREDIT.CustomerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.CreditId IS NULL AND
      inserted.CustomerID IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PAYMENT because CUSTOMER_CREDIT does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CUSTOMER Hi PAYMENT on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="Hi", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Payment", FK_COLUMNS="CustomerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,CUSTOMER
        WHERE
          /* %JoinFKPK(inserted,CUSTOMER) */
          inserted.CustomerID = CUSTOMER.CustomerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.CustomerID IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PAYMENT because CUSTOMER does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_MOVIE ON MOVIE FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on MOVIE */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* STREAMING_SERVICE  MOVIE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00017c9d", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="MOVIE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie", FK_COLUMNS="ServiceId" */
    IF EXISTS (SELECT * FROM deleted,STREAMING_SERVICE
      WHERE
        /* %JoinFKPK(deleted,STREAMING_SERVICE," = "," AND") */
        deleted.ServiceId = STREAMING_SERVICE.ServiceId AND
        NOT EXISTS (
          SELECT * FROM MOVIE
          WHERE
            /* %JoinFKPK(MOVIE,STREAMING_SERVICE," = "," AND") */
            MOVIE.ServiceId = STREAMING_SERVICE.ServiceId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last MOVIE because STREAMING_SERVICE exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_MOVIE ON MOVIE FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on MOVIE */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insServiceId integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* STREAMING_SERVICE  MOVIE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="000190ab", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="MOVIE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie", FK_COLUMNS="ServiceId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ServiceId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,STREAMING_SERVICE
        WHERE
          /* %JoinFKPK(inserted,STREAMING_SERVICE) */
          inserted.ServiceId = STREAMING_SERVICE.ServiceId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update MOVIE because STREAMING_SERVICE does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PAYMENT_RECORD ON PAYMENT_RECORD FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PAYMENT_RECORD */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PAYMENT  PAYMENT_RECORD on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000157c1", PARENT_OWNER="", PARENT_TABLE="PAYMENT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT_RECORD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Payment_Payment_Record", FK_COLUMNS="PaymentId" */
    IF EXISTS (SELECT * FROM deleted,PAYMENT
      WHERE
        /* %JoinFKPK(deleted,PAYMENT," = "," AND") */
        deleted.PaymentId = PAYMENT.PaymentId AND
        NOT EXISTS (
          SELECT * FROM PAYMENT_RECORD
          WHERE
            /* %JoinFKPK(PAYMENT_RECORD,PAYMENT," = "," AND") */
            PAYMENT_RECORD.PaymentId = PAYMENT.PaymentId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PAYMENT_RECORD because PAYMENT exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_PAYMENT_RECORD ON PAYMENT_RECORD FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PAYMENT_RECORD */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insPaymentId integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PAYMENT  PAYMENT_RECORD on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001875d", PARENT_OWNER="", PARENT_TABLE="PAYMENT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT_RECORD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Payment_Payment_Record", FK_COLUMNS="PaymentId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(PaymentId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PAYMENT
        WHERE
          /* %JoinFKPK(inserted,PAYMENT) */
          inserted.PaymentId = PAYMENT.PaymentId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PAYMENT_RECORD because PAYMENT does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_CUSTOMERCREDIT ON CUSTOMER_CREDIT FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on CUSTOMER_CREDIT */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* CUSTOMER_CREDIT  PAYMENT on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000283ef", PARENT_OWNER="", PARENT_TABLE="CUSTOMER_CREDIT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Credit_Payment", FK_COLUMNS="CreditId""CustomerID" */
    IF EXISTS (
      SELECT * FROM deleted,PAYMENT
      WHERE
        /*  %JoinFKPK(PAYMENT,deleted," = "," AND") */
        PAYMENT.CreditId = deleted.CreditId AND
        PAYMENT.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete CUSTOMER_CREDIT because PAYMENT exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CUSTOMER  CUSTOMER_CREDIT on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="CUSTOMER_CREDIT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Customer_Credit", FK_COLUMNS="CustomerID" */
    IF EXISTS (SELECT * FROM deleted,CUSTOMER
      WHERE
        /* %JoinFKPK(deleted,CUSTOMER," = "," AND") */
        deleted.CustomerID = CUSTOMER.CustomerID AND
        NOT EXISTS (
          SELECT * FROM CUSTOMER_CREDIT
          WHERE
            /* %JoinFKPK(CUSTOMER_CREDIT,CUSTOMER," = "," AND") */
            CUSTOMER_CREDIT.CustomerID = CUSTOMER.CustomerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last CUSTOMER_CREDIT because CUSTOMER exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_CUSTOMERCREDIT ON CUSTOMER_CREDIT FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on CUSTOMER_CREDIT */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insCreditId integer, 
           @insCustomerID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* CUSTOMER_CREDIT  PAYMENT on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002bfd0", PARENT_OWNER="", PARENT_TABLE="CUSTOMER_CREDIT"
    CHILD_OWNER="", CHILD_TABLE="PAYMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Credit_Payment", FK_COLUMNS="CreditId""CustomerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CreditId) OR
    UPDATE(CustomerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PAYMENT
      WHERE
        /*  %JoinFKPK(PAYMENT,deleted," = "," AND") */
        PAYMENT.CreditId = deleted.CreditId AND
        PAYMENT.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update CUSTOMER_CREDIT because PAYMENT exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CUSTOMER  CUSTOMER_CREDIT on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="CUSTOMER_CREDIT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Customer_Credit", FK_COLUMNS="CustomerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,CUSTOMER
        WHERE
          /* %JoinFKPK(inserted,CUSTOMER) */
          inserted.CustomerID = CUSTOMER.CustomerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update CUSTOMER_CREDIT because CUSTOMER does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Movie_Rent ON Movie_Rent FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Movie_Rent */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* CUSTOMER  Movie_Rent on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002e91a", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Movie_Rent", FK_COLUMNS="CustomerID" */
    IF EXISTS (SELECT * FROM deleted,CUSTOMER
      WHERE
        /* %JoinFKPK(deleted,CUSTOMER," = "," AND") */
        deleted.CustomerID = CUSTOMER.CustomerID AND
        NOT EXISTS (
          SELECT * FROM Movie_Rent
          WHERE
            /* %JoinFKPK(Movie_Rent,CUSTOMER," = "," AND") */
            Movie_Rent.CustomerID = CUSTOMER.CustomerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Movie_Rent because CUSTOMER exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* STREAMING_SERVICE Streaming_Service_To_Movie_Rent Movie_Rent on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="Streaming_Service_To_Movie_Rent", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie_Rent", FK_COLUMNS="ServiceId" */
    IF EXISTS (SELECT * FROM deleted,STREAMING_SERVICE
      WHERE
        /* %JoinFKPK(deleted,STREAMING_SERVICE," = "," AND") */
        deleted.ServiceId = STREAMING_SERVICE.ServiceId AND
        NOT EXISTS (
          SELECT * FROM Movie_Rent
          WHERE
            /* %JoinFKPK(Movie_Rent,STREAMING_SERVICE," = "," AND") */
            Movie_Rent.ServiceId = STREAMING_SERVICE.ServiceId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Movie_Rent because STREAMING_SERVICE exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_Movie_Rent ON Movie_Rent FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Movie_Rent */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insMovieId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* CUSTOMER  Movie_Rent on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00034012", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Customer_Movie_Rent", FK_COLUMNS="CustomerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,CUSTOMER
        WHERE
          /* %JoinFKPK(inserted,CUSTOMER) */
          inserted.CustomerID = CUSTOMER.CustomerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.CustomerID IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Movie_Rent because CUSTOMER does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* STREAMING_SERVICE Streaming_Service_To_Movie_Rent Movie_Rent on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="Streaming_Service_To_Movie_Rent", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie_Rent", FK_COLUMNS="ServiceId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ServiceId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,STREAMING_SERVICE
        WHERE
          /* %JoinFKPK(inserted,STREAMING_SERVICE) */
          inserted.ServiceId = STREAMING_SERVICE.ServiceId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.ServiceId IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Movie_Rent because STREAMING_SERVICE does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_STREAMING_SERVICE ON STREAMING_SERVICE FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on STREAMING_SERVICE */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* STREAMING_SERVICE Streaming_Service_To_Movie_Rent Movie_Rent on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003837f", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="Streaming_Service_To_Movie_Rent", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie_Rent", FK_COLUMNS="ServiceId" */
    IF EXISTS (
      SELECT * FROM deleted,Movie_Rent
      WHERE
        /*  %JoinFKPK(Movie_Rent,deleted," = "," AND") */
        Movie_Rent.ServiceId = deleted.ServiceId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete STREAMING_SERVICE because Movie_Rent exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* STREAMING_SERVICE  MOVIE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="MOVIE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie", FK_COLUMNS="ServiceId" */
    IF EXISTS (
      SELECT * FROM deleted,MOVIE
      WHERE
        /*  %JoinFKPK(MOVIE,deleted," = "," AND") */
        MOVIE.ServiceId = deleted.ServiceId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete STREAMING_SERVICE because MOVIE exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* CUSTOMER  STREAMING_SERVICE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="STREAMING_SERVICE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Customer", FK_COLUMNS="CustomerID" */
    IF EXISTS (SELECT * FROM deleted,CUSTOMER
      WHERE
        /* %JoinFKPK(deleted,CUSTOMER," = "," AND") */
        deleted.CustomerID = CUSTOMER.CustomerID AND
        NOT EXISTS (
          SELECT * FROM STREAMING_SERVICE
          WHERE
            /* %JoinFKPK(STREAMING_SERVICE,CUSTOMER," = "," AND") */
            STREAMING_SERVICE.CustomerID = CUSTOMER.CustomerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last STREAMING_SERVICE because CUSTOMER exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_STREAMING_SERVICE ON STREAMING_SERVICE FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on STREAMING_SERVICE */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insServiceId integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* STREAMING_SERVICE Streaming_Service_To_Movie_Rent Movie_Rent on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0003e6b8", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="Movie_Rent"
    P2C_VERB_PHRASE="Streaming_Service_To_Movie_Rent", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie_Rent", FK_COLUMNS="ServiceId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ServiceId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Movie_Rent
      WHERE
        /*  %JoinFKPK(Movie_Rent,deleted," = "," AND") */
        Movie_Rent.ServiceId = deleted.ServiceId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update STREAMING_SERVICE because Movie_Rent exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* STREAMING_SERVICE  MOVIE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STREAMING_SERVICE"
    CHILD_OWNER="", CHILD_TABLE="MOVIE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Movie", FK_COLUMNS="ServiceId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ServiceId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,MOVIE
      WHERE
        /*  %JoinFKPK(MOVIE,deleted," = "," AND") */
        MOVIE.ServiceId = deleted.ServiceId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update STREAMING_SERVICE because MOVIE exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* CUSTOMER  STREAMING_SERVICE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CUSTOMER"
    CHILD_OWNER="", CHILD_TABLE="STREAMING_SERVICE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="FK_Streaming_Service_Customer", FK_COLUMNS="CustomerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,CUSTOMER
        WHERE
          /* %JoinFKPK(inserted,CUSTOMER) */
          inserted.CustomerID = CUSTOMER.CustomerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.CustomerID IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update STREAMING_SERVICE because CUSTOMER does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go
