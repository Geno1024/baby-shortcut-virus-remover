@echo off
echo 0. 灭活处理
taskkill /f /im wscript.exe

echo 1. 切换到 U 盘
rem wmic logicaldisk 列出磁盘
rem drivetype 2 类型就是 U 盘
rem 据说 Window$ 7 之前不能使用 wmic？有实际环境时再测试
for /f "skip=1" %%i in ('wmic logicaldisk where "drivetype=2" get caption') do %%i

echo 2. 去掉 U 盘中全部文件的系统、隐藏属性
rem "System Volume Information" 文件夹很可能遭殃，但是没关系的吧这……
rem 有些电脑 PATH 环境变量被干掉的……修改为 %windir%/system32/attrib
attrib -s -h /s /d *.*

echo 3. 删掉那些快捷方式
rem U 盘根目录要啥快捷方式……
del *.lnk
echo 4. 删掉 WScript 脚本文件，潜在的病毒
rem 一般没人在 U 盘根目录放这种文件的吧……
del *.wsf *.vbs *.vbe *.wsc

echo 5. 查询注册表
rem 将执行输出传递给变量的正确姿势！
rem HKLM 是不是也得搞搞……
for /f "tokens=*" %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run ^| find "wscript"') do set result=%%i
echo 6. 获得指向病毒的自启动项
rem tokens 指定要拿第几个使用 delims 分割的段
for /f "tokens=1" %%i in ('echo %result%') do set reg=%%i
echo 7. 获得病毒的真正路径
rem 事实上不能确定此处的双引号作为 delimiter 是不是恰当的行为……
rem 目前的写法来源是 https://stackoverflow.com/questions/7516064/escaping-double-quote-in-delims-option-of-for-f
rem https://ss64.com/nt/for_cmd.html 中提到一种方式，tokens 使用形如 3* 这样的，能拿到从 3 开始到最后一段
rem 但是这里 Window$ 10 (10.0.17025.1000) 表示失败
for /F delims^=^"^ tokens^=2 %%i in ('echo %result%') do set virus=%%i

echo 8. 删除这个自启动项
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %reg% /f
echo 9. 删除病毒
del %virus%
echo 10. 嗯现在这个电脑和这个 U 盘都没事了……但是这仍然不能避免下次有其它 U 盘将病毒带来到这个电脑中
echo 如果有人有免疫的什么思路，请告诉我
echo 我也不说我是谁（
pause
