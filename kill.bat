@echo off
echo 0. ����
taskkill /f /im wscript.exe

echo 1. �л��� U ��
rem wmic logicaldisk �г�����
rem drivetype 2 ���;��� U ��
rem ��˵ Window$ 7 ֮ǰ����ʹ�� wmic����ʵ�ʻ���ʱ�ٲ���
for /f "skip=1" %%i in ('wmic logicaldisk where "drivetype=2" get caption') do %%i

echo 2. ȥ�� U ����ȫ���ļ���ϵͳ����������
rem "System Volume Information" �ļ��кܿ������꣬����û��ϵ�İ��⡭��
rem ��Щ���� PATH �����������ɵ��ġ����޸�Ϊ %windir%/system32/attrib
for %%f in (.\*) do (attrib -s -h %%f)

echo 3. ɾ����Щ��ݷ�ʽ
rem U �̸�Ŀ¼Ҫɶ��ݷ�ʽ����
del *.lnk
echo 4. ɾ�� WScript �ű��ļ���Ǳ�ڵĲ���
rem һ��û���� U �̸�Ŀ¼�������ļ��İɡ���
del *.wsf *.vbs *.vbe *.wsc

echo 5. ��ѯע���
rem ��ִ��������ݸ���������ȷ���ƣ�
rem HKLM �ǲ���Ҳ�ø�㡭��
for /f "tokens=*" %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run ^| find "wscript"') do set result=%%i
echo 6. ���ָ�򲡶�����������
rem tokens ָ��Ҫ�õڼ���ʹ�� delims �ָ�Ķ�
for /f "tokens=1" %%i in ('echo %result%') do set reg=%%i
echo 7. ��ò���������·��
rem ��ʵ�ϲ���ȷ���˴���˫������Ϊ delimiter �ǲ���ǡ������Ϊ����
rem Ŀǰ��д����Դ�� https://stackoverflow.com/questions/7516064/escaping-double-quote-in-delims-option-of-for-f
rem https://ss64.com/nt/for_cmd.html ���ᵽһ�ַ�ʽ��tokens ʹ������ 3* �����ģ����õ��� 3 ��ʼ�����һ��
rem �������� Window$ 10 (10.0.17025.1000) ��ʾʧ��
for /F delims^=^"^ tokens^=2 %%i in ('echo %result%') do set virus=%%i

echo 8. ɾ�������������
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %reg% /f
echo 9. ɾ������
del %virus%
echo 10. ������������Ժ���� U �̶�û���ˡ�����������Ȼ���ܱ����´������� U �̽��������������������
echo ������������ߵ�ʲô˼·���������
echo ��Ҳ��˵����˭��
pause
