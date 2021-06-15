trigger consumazionipagate on Order (after delete) {
    HandleTriggerConsumazioni.adelete(Trigger.oldmap);
}