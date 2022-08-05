trigger ReservaTrigger on Opportunity (before insert,before update,before delete,after insert,after update, after delete, after undelete) {
    triggerHandler handler = new ReservaTriggerHandler(Trigger.isExecuting, Trigger.size);  
    
    switch on trigger.OperationType {
        when before_insert {
            system.System.debug('El desencadenador es antes de insertar');
            handler.beforeInsert(trigger.new);
        }
        when before_update{
            system.System.debug('El desencadenador es antes de update');
            handler.beforeUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when before_delete{ 
            system.System.debug('El desencadenador es antes de delete');
            handler.beforeDelete(trigger.old,trigger.oldMap);
        }
        when after_insert {
            system.System.debug('El desencadenador es despues de insertar');
            handler.afterInsert(trigger.new,trigger.newMap);
        }
        when after_update {
            system.System.debug('El desencadenador es despues de update');
            handler.afterUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when after_delete {
            system.System.debug('El desencadenador es despues de delete');
            handler.afterDelete(trigger.old,trigger.oldMap);
        }
        when after_undelete{
            system.debug('El desencadenador es despues de undelete');
            handler.afterUndelete(trigger.new,trigger.newMap);
        }        
        when else {
            system.System.debug('El desencadenador es nada');
        }

        
    }
}