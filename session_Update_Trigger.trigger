trigger session_Update_Trigger on Session__c (before update) {

    if(Trigger.isUpdate == True)
    {
        integer i = 0;
        ID[] strNewId = new ID[]{};
        ID[] strSpeakerIDs = new ID[]{};//Yatin
        String strIDs = '';

        DateTime[] dtOldSessionDate = new DateTime[]{};
        DateTime[] dtNewSessionDate = new DateTime[]{};

        for(i=0;i<Trigger.old.size();i++)
        {
        	dtOldSessionDate.add(Trigger.old[i].session_date__c);
        	dtNewSessionDate.add(Trigger.New[i].session_date__c);
            strNewId.add(Trigger.New[i].ID);
        }

        for(i=0;i<strNewId.size();i++)
        {
            if(dtOldSessionDate[i] != dtNewSessionDate[i])
            {
                List <session_speaker__c> spOfCurrSS = [SELECT speaker__c FROM session_speaker__c WHERE session__c IN: strNewId];

                for(session_speaker__c ss : spOfCurrSS)
                {
                    strSpeakerIDs.add(ss.speaker__c);
                }

                List <session_speaker__c> spOfOneSS = [SELECT speaker__c, session__r.session_date__c, session__r.Name, speaker__r.First_name__c, speaker__r.last_name__c FROM session_speaker__c WHERE speaker__c IN: strSpeakerIDs AND session__c !=: strNewId AND session__r.session_date__c =: dtNewSessionDate[i]];
                if(!(spOfOneSS.isEmpty()))
                {
                    Trigger.New[i].addError('Duplicate booking found for Speaker: '+ spOfOneSS[0].speaker__r.First_name__c +' with Session: '+ spOfOneSS[0].session__r.Name);
                }
            }
		}
    }
}