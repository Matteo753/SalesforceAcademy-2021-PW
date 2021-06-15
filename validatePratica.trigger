trigger validatePratica on Contract (before insert,after insert) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{
            HandleTriggerValidatePratica.binsert(Trigger.new);
        }
        /*
        when AFTER_INSERT{
            HandleTriggerValidatePratica.ainsert(Trigger.new);
        }
        */
    }
}