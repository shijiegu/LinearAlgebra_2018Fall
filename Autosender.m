%% outgoing mail setting
% https://undocumentedmatlab.com/blog/sending-email-text-messages-from-matlab
mail = '***';    % Replace with your email address
password = '***';          % Replace with your email password
server = 'smtp.shanghaitech.edu.cn';     % Replace with your SMTP server
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.port','587');
props.setProperty('mail.smtp.auth','true');  % Note: 'true' as a string, not a logical value!
props.setProperty('mail.smtp.starttls.enable','true');  % Note: 'true' as a string, not a logical value!
props.setProperty('mail.smtp.socketFactory.port','587');   % Note: '465'  as a string, not a numeric value!
%props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory');
% Apply prefs and props
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server',server);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
%% Writing the email
msg=['Dear %s (Student ID %s) \n',...
     '  Your homework score on week %s is: %s \n',...
     '  Scores are recorded in terms of points taken off (0 means full mark). NaN means I have not received your homework that week. \n',...
     '  Please also check if you agree with my gradings so far.\n',...
     '  If you believe you have submitted your work but have NaN scores, please let me know.\n',...
     'Best,\n',...
     'Shijie'];
%% data

[num,txt,raw] = xlsread('/Users/gushijie/Documents/University11/Class-list.xlsx','Sheet1');
headings=raw(1,:);
mail_col=7;
name_col=2;
ID_col=find(strcmp(headings,'Student No'));

%%
% Send the email
hw_name='1-8';
score_col=8:15;
email_name='[LA] IMPORTANT check Homework 1-8 Scores';
debug=0;
error_ID=[];
for s=2:size(raw,1)
    student_row=s;
    scores=cell2mat(raw(student_row,score_col));
    student_name=raw{student_row,name_col};
    student_ID=num2str(raw{student_row,ID_col});
    student_email=raw{student_row,mail_col};
    if sum(isnan(scores))==length(score_col) %isnan=length(score_col) means that student has never submitted hw to me, not my student
        continue
    end
    msg_full=sprintf(msg,student_name,student_ID,...
        hw_name,mat2str(scores));
    if debug
        sendmail('shijiegu@mit.edu','Test',msg_full);
    else
        try
            sendmail(student_email,email_name,msg_full);
        catch
            error_ID=[error_ID,s];
        end
    end
    pause(5)
    disp(['Done sending to ID: ' student_ID]);
end
