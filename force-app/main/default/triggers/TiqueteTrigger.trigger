trigger TiqueteTrigger on OpportunityLineItem (before insert,before update,before delete,after insert,after update, after delete, after undelete) {

    triggerHandler handler = new tiqueteTriggerHandler(Trigger.isExecuting, Trigger.size);  
    
    switch on trigger.OperationType {
        when before_insert {
            system.System.debug('El desencadenador es antes de insertar');
            handler.beforeInsert(trigger.new);
        }
        when before_update{
            system.System.debug('El desencadenador es antes de update');
        }
        when before_delete{ 
            system.System.debug('El desencadenador es antes de delete');
        }
        when after_insert {
            system.System.debug('El desencadenador es despues de insertar');
            handler.afterInsert(trigger.new,trigger.newMap);
        }
        when after_update {
            system.System.debug('El desencadenador es despues de update');
        }
        when after_delete {
            system.System.debug('El desencadenador es despues de delete');
        }
        when after_undelete{
            system.System.debug('El desencadenador es despues de undelete');
        }        
        when else {
            system.System.debug('El desencadenador es nada');
        }
    }

}