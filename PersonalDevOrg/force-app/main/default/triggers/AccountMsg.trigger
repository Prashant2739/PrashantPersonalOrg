trigger AccountMsg on Account (before insert) {
    for (account a: Trigger.new){
    if (a.industry == 'Education')
    a.addError('We do not work with education orgs anymore'); 
   }       
}