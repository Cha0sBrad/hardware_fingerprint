#-*- coding:utf-8 -*-
import wmi
import win32api,win32con
import json
dict = {}
def fetch_hw_fingerprint():
    global dict
    sysinfo = wmi.WMI()
    dict["Type"] = "Windows"
    dict["Version"] = "Windows 7/Windows 10"
    dict["Architecture"] = "x86/x64"
    for bios in sysinfo.Win32_BIOS():
        dict["BIOS_Version"] = bios.Version
        dict["BIOS_Caption"] = bios.Caption
        dict["BIOS_SerialNumber"] = bios.SerialNumber
        dict["BIOS_Modifiability"] = u"不可更改"

    for BaseBoard in sysinfo.Win32_BaseBoard():
        dict["BaseBoard_Manufacturer"] = BaseBoard.Manufacturer
        dict["BaseBoard_Product"] = BaseBoard.Product
        dict["BaseBoard_Version"] = BaseBoard.Version
        dict["BaseBoard_SerialNumber"] = BaseBoard.SerialNumber
        dict["BaseBoard_Modifiability"] = u"不可更改"

    for product in sysinfo.Win32_ComputerSystemProduct():
        dict["Product_Vendor"] = product.Vendor
        dict["Product_Name"] = product.Name
        dict["Product_Version"] = product.Version
        dict["Product_Modifiability"] = u"不可更改"

    for disk in sysinfo.Win32_DiskDrive():
        dict["DiskDrive_Model"] = disk.Model
        dict["DiskDrive_Size"] = (int(disk.Size)/1024/1024/1024)
        dict["DiskDrive_Modifiability"] = "不可更改"

    for Memory in sysinfo.Win32_PhysicalMemory():
        dict["Memory_Size"] = (int(Memory.Capacity) / 1048576)
        dict["Memory_Modifiability"] = u"不可更改"

    for os in sysinfo.Win32_OperatingSystem():
        dict["OS_Caption"] = os.Caption
        dict["OS_Architecture"] = os.OSArchitecture
        dict["OS_Version"] = os.Version
        dict["OS_SystemDirectory"] = os.SystemDirectory
        dict["OS_Modifiability"] = u"不易更改"

    for cpu in sysinfo.Win32_Processor():
        dict["CPU_DeviceID"] = cpu.DeviceID
        dict["CPU_Name"] = cpu.Name
        dict["CPU_Modifiability"] = u"不易更改"

    for network in sysinfo.Win32_NetworkAdapterConfiguration (IPEnabled=1):
        if(network.Description.find('Virtual')!=-1):
            continue
        dict["Description"] = network.Description
        dict["Mac Address"] = network.MACAddress
        dict["IP Address"] = network.IPAddress[0]
        dict["Modifiability"] = u"root可改"

    for ComputerSystem in sysinfo.Win32_ComputerSystem():
        dict["Computer_Name"] = ComputerSystem.Name
        dict["Computer_UserName"] = ComputerSystem.UserName
        dict["Computer_SystemType"] = ComputerSystem.SystemType
        dict["Computer_Modifiability"] = u"root可改"

    for TimeZone in sysinfo.Win32_TimeZone():
        dict["TimeZone_Caption"] = TimeZone.Caption
        dict["TimeZone_Modifiability"] = u"user可改"

    dict[u"分辨率"] = str(win32api.GetSystemMetrics(win32con.SM_CXSCREEN))+'*'+str(win32api.GetSystemMetrics(win32con.SM_CYSCREEN))
    dict["Modifiability"] = u"user可改"

    return json.dumps(dict,indent = 4,ensure_ascii=False)