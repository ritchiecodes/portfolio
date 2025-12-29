---
layout: post
title: "Bad Actors can Hide Outlook/Exchange Rules"
tags: [cybersecurity, outlook, email, vulnerability]
thumbnail: 
---
**Introduction**

It was just another Monday morning, I rolled into work sat at my desk ready to start the day.
I received a message on microsoft teams from our cybersecurity department notifiyng me of a breach over the weekend that affected some users.
Without going into too much detail, the breach involved the bad actor gaining access to a users account and then distributing a phishing campaign through a sharepoint file.

Today, my task was simple, to assist the end users with changing their passwords, ensuring 2fa via an authetnicator app was setup and finally giving them access to their account again.

After going through this process with a few users, I noticed that none of them had received any emails since Friday, since it had just been the weekend this might not seem strange but I decided to dig deeper. I sent a test email and my suspicions had been confirmed, the email did not reach their inbox.
After searching for the email in outlook I found that it did in fact arrive, but it was sitting in the Archive folder, as were all the emails they had received since Friday.

Now things were starting to become clearer, there must be an outlook rule setup by the bad actor to hide any incoming emails. This was not the case though, there were no rules setup in their outlook client, or so I thought.
After a little bit more research I came across information from different sources claiming a similar thing had happened to them or to others in their organisation. This is when I learnt that Microsoft have left a very simple, yet effective exploit that allows someone to hide your Outlook/Exchange rules from the Rules GUI in Outlook.

Below, I explain how I recreated this exploit on my own machine, how I viewed the hidden rules, how I removed/deleted the hidden rules for the affected users and finally how to check for any more hidden rules across all accounts within the organisation.

**The Attack**

How is the attack executed?
<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/hidden-rule-attack.webp"
    alt="Hidden Rule Attack Steps"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
</figure>

*In our case, emails were unable to be forwarded externally,
so the bad actor had a rule that moved the email out of sight
to buy time before the victim realised they had been compromised.

To keep things brief, we will assume the attacker has already completed steps 1 and 2 and has access to the victims mailbox via Outlook.

Step 3 is as simple as creating an Outlook inbox rule that forwards emails to the attacker (or elsewhere)
<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/create-rule.png"
    alt="Create Inbox Rule"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Creating an inbox rule in Outlook</figcaption>
</figure>

Once created, the rule is still currently visibile in the "Rules and Alerts" window.

Step 4
The aim of step 4 is to now hide the rule.
This exploit makes the rule almost undetectable by normal means, it will not appear inside email clients or common administration tools. To demonstrate this, I will use a rule that moves emails to the archive folder when they have the subject "Hidden Test"
<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/rule-demonstration.png"
    alt="Inbox Rule Demonstration"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Rule that we are going to hide</figcaption>
</figure>

Now, to actually hide the rule we can make use of Microsoft's Messaging API. MAPI is a middleware that allows messaging applications like Outlook to access the messaging subsystems found in Windows.
To recreate the attack we can use Microsofts own software "MFCMapi" available from Microsofts Github Repository.
Below is MFCMapi outputting the raw data of the Rule we would like to hide.
1. Open the Inbox in MFCMapi
2. Go to Folder>View>Hidden Contents
3. Find the IPM.Rule.Version2.Message in the Message Class column. (There will be one for each rule)
4. Find the PR_RULE_MSG_NAME and PR_RULE_MSG_PROVIDER properties and clear the Value field

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/mfcmapi-investigation.png"
    alt="MFCMapi Rule Location"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Rule opened in MFCMapi</figcaption>
</figure>

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/mfcmapi-changes.png"
    alt="MFCMapi Rule Tampering"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Tampering rule properties in MFCMapi</figcaption>
</figure>






**How to Detect Hidden Rules**

As we can see when looking at our list of rules now, the Hidden Rule is now invisible.

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/rule-is-hidden.png"
    alt="Rule is now hidden"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Rules and Alerts show no rules</figcaption>
</figure>



Lets test if the Rule is still enabled though, after senidng an email that meets the rules requiremenets, you can see the email rule is still active despite being hidden.

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/email-in-archive.png"
    alt="Email showing in Archive Folder"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Email showing in Archive folder</figcaption>
</figure>


So how do we detect if a user has a hidden rule lurking in their mailbox?

Well, we can always use MFCMapi to investigate suspicious mailbox behaviour but this requires us to manually investigate and would become tedious at a large scale.
Thankfully, Powershell comes to the rescue.

Firstly, we need to connect to exchange online with Connect-ExchangeOnline

```ps
Get-InboxRule -Mailbox example@example.com -IncludeHidden
```

We can see a rule with a string of numbers, this is in fact the hidden rule.

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/Get-InboxRule.png"
    alt="Get-InboxRule Command"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Get-InboxRule Command</figcaption>
</figure>


**Removing the Hidden Rule**
There are two ways I found to delete this rule. 

1. Deleting the Rule via Powershell with `Remove-InboxRule -Mailbox example@work.com -Identity "RULE IDENTITY`
2. Open "Run" enter outlook /cleanrules (CAREFULL: This will delete all rules that have been created in that outlook account.)

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/remove-rule.png"
    alt="Remove-InboxRule Command"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Remove-InboxRule Command</figcaption>
</figure>

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/clean-rules.png"
    alt="Outlook Clean Rules Flag"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Outlook Clean Rules Flag</figcaption>
</figure>

Both options are simple and easy if only a few people have been impacted but how can we ensure there are no hidden rules lurking within the organisation.
I wrote a neat script to aid in investigating just this.

```ps
$mailboxes = Get-EXOMailbox -ResultSize unlimited
$output = @()
Foreach ($mailbox in $mailboxes) {
    $hiddenrules = Get-InboxRule -Mailbox $mailbox -IncludeHidden | Where-Object {$_.Name -notin (Get-InboxRule -Mailbox $mailbox).name -and ($_.Name -ne "Junk E-Mail Rule")}
If ($hiddenrules) {
    Foreach ($rule in $hiddenrules) {
        $output += [PSCustomObject]@{
            Email = $mailbox.UserPrincipalName
            Rule = $rule.Name
    }
    Write-Host $mailbox.UserPrincipalName $rule.name -ForegroundColor Red
}
}
Write-Host "Checked $mailbox" -ForegroundColor Cyan
}

$output | Export-CSV "OUTPUT_PATH.csv"
```

Ensure you change the Export-CSV "OUTPUT PATH.csv" to the path you would like to save the results.

Great! Now you have a list of any suspicious rules and the account associated with it.
This next script will take those rules and give you the description of what the rule is actually doing.

```ps
$output = @()
$rules = Get-Inboxrule -mailbox "EXCHANGE_EMAIL" -IncludeHidden | Select-Object name, description
foreach($rule in $rules){
$desc = $rule.description -replace "`r?`n", " "
$output += [PSCustomObject]@{
                RuleName  = $rule.name
                RuleDesc  = $desc
    }
}
$output | Export-Csv "OUTPUT_PATH.csv"
```
Again, change the Export-CSV "OUTPUT PATH.csv" to the path you would like to save the results.

<figure style="margin-left:auto; margin-right:auto; text-align:center;">
  <img 
    src="/assets/images/hidden-rules/Get-InboxRule.png"
    alt="Get-InboxRule Command"
    width="600"
    style="display:block; margin-left:auto; margin-right:auto;">
    <figcaption>Get-InboxRule Command</figcaption>
</figure>

Now with this information you can make an informed decision, is this a malicious hidden rule? or something else.

**Conclusion**

Despite our best efforts, a compromised account can't always be considered safe after a password reset and revoking session tokens.
This is just one of the ways damage can be caused to a compromised account, a proper in-depth forensic investigation is necessary to uncover any other malicious or harmful practices that may have been enacted on the victims account.
It is safe practice to disable the ability to forward emails to an external domain, in this case we were able to mitigate further potential damage by having this setup in place.

Microsoft have deemed the ability to hide inbox rules to not be a vulnerability as it requires the bad actor to have access to the users account. I am yet to figure out any legitimate use cases for hiding rules in Outlook but alas the ability to hide them exists.

A simple Monday morning turned out to be a day of investigation, mitigation, and eradication.
In future, we will periodically run the scripts I created to ensure that there are no hidden rules that could impact someones account.







