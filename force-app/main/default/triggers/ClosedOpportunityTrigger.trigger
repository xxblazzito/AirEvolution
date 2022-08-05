trigger ClosedOpportunityTrigger on Opportunity (after insert,after update)
{
    List<Task> taskList = new List<Task>();
    for (Opportunity opp : trigger.new)
    {
        If(Trigger.isInsert)
        {
            if(Opp.StageName == 'Closed Won')
            {
                taskList.add(new task(Subject ='Follow Up Test Task',WhatId = opp.Id));
            } 
        }
        If(Trigger.isUpdate)
        {
            IF(opp.StageName == 'Closed Won' && opp.StageName != trigger.oldMap.get(opp.Id).StageName)
            {
                taskList.add(new task(Subject ='Follow Up Test Task',WhatId = opp.Id));
            }

        }
        

    }
    If(taskList.size() > 0)
        {
            insert taskList;

        }
}