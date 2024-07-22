USE master
GO
--THEN MUST JOIN PRIMARY REPLICA (FORWARDER)
ALTER AVAILABILITY GROUP [PRODAPP_DISTAG]   
   JOIN   
   AVAILABILITY GROUP ON  
      'AGAZPRIM' WITH    
      (   
         LISTENER_URL = 'tcp://LISTAZPRIM.ppg.local:5022',    
         AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
         FAILOVER_MODE = MANUAL,   
         SEEDING_MODE = MANUAL   
      ),   
      'PPGPRDAPPAG' WITH    
     (   
        LISTENER_URL = 'tcp://PPGPRDAPPAGL.procind.local:5022',   
         AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
         FAILOVER_MODE = MANUAL,   
         SEEDING_MODE = MANUAL   
      );      
GO