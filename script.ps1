## Includes
. ./Get-SanitizedString.ps1
#Import-Module ActiveDirectory

## Read attributes from 4me request

$auth_token = ''
$account_id = ''
$request_id = ''

# GET /requests/:id
$4me_params = @{
    Method = 'GET';
    Uri = "https://api.4me-demo.com/v1/api/requests/$request_id";
    ContentType = 'application/json';
}

## <personal-access-token>
$header = @{
    "Authorization" = "Bearer $auth_token";
    'X-4me-Account' = $account_id;
}
#$request = ( Invoke-RestMethod @4me_params -Headers $header ) | ConvertFrom-Json
# $request.requested_by.name etc...
# $request.custom_fields.manager


## Turn 4me request fields into AD params
 $first_name = $request.custom_fields.first_name
 $last_name = $request.custom_fields.last_name

$samaccount_to_copy = 'michael.baer'
$domain = 'muller.co.uk'
$samaccount_name = "$first_name.$last_name"
$upn = "$new_samaccountname.$domain"
$display_name = "$last_name, $first_name     / DD_"
$full_name = 'Baer, Test'
$description = 'Testing my script'
$profile_path = 'kix32.exe bla.kix'
$password = 'R4nd0m@ssP@55w0rd'
$ou_DN = ''
$enable_user_after_creation = $true
$password_never_expires = $false
$cannot_change_password = $false

# site --> OU, address --> country, city
# job_title
#$company =  $request.custom_fields.manager
# org_unit
#$manager = $request.custom_fields.manager
# ext1 = internal
# ext2 = ...
#$employeeID = $request.custom_fields.manager
# ext4 = costCentre = ...

## Retrieve the reference `ADUser` with its group memberships
#$ad_account_to_copy = Get-ADUser $samaccount_to_copy -Properties MemberOf

$ad_params = @{'Instance' = $ad_account_to_copy;
            'SamAccountName' = $samaccount_name;
            'UserPrincipalName' = $upn;
            'DisplayName' = $display_name;
            'GivenName' = $first_name;
            'SurName' = $last_name;
            'Description' = $description;
            'ProfilePath' = $profile_path
            'Enabled' = $enable_user_after_creation;
            'PasswordNeverExpires' = $password_never_expires;
            'CannotChangePassword' = $cannot_change_password;
            'AccountPassword' = (ConvertTo-SecureString -AsPlainText $password -Force);
}

## Create the new user account
#New-ADUser -Name $full_name @ad_params

## Mirror all the groups the original account was a member of
#$ad_account_to_copy.MemberOf | ForEach-Object {Add-ADGroupMember $_ $samaccount_name }

## Move the new user account into the assigned OU
#Get-ADUser $new_samaccountname | Move-ADObject -TargetPath $ou_DN

## Only set if different from $upn
$email = 'test.baer@muller.co.uk'

$mailbox_params = @{'Database' = 'New_User';
            'EmailAddresses' = @{'add' = $email};
            'EmailAddressPolicyEnabled' = $false;
}

## Create a mailbox for the newly created user
#Enable-Mailbox -Identity $upn @mailbox_params

Get-SanitizedString "Michaél O'Mally (!)"


## Logic from https://adamtheautomator.com/active-directory-scripts/
## https://github.com/adbertram/Random-PowerShell-Work/blob/master/ActiveDirectory/Copy-AD-User-Account.ps1


