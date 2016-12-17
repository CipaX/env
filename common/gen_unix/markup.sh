#!/bin/bash

source "${SMARTPROF_DIR_COMMON_GEN_LINUX}/colors.sh"

# Dark Theme

function darkEchoWarning()
{
   echo -e "${HYellow}$@${ResetColor}"
}

function darkEchoError()
{
   echo -e "${BHRed}$@${ResetColor}"
}

function darkEchoT1()
{
   echo -e "${BUHBlue}### $@ ###${ResetColor}"
}

function darkEchoT2()
{
   echo -e "${BUHMagenta}## $@ ##${ResetColor}"
}

function darkEchoT3()
{
   echo -e "${BUHCyan}# $@ #${ResetColor}"
}

function darkEchoH1()
{
   echo -e "${BHBlue}=== $@ ===${ResetColor}"
}

function darkEchoH2()
{
   echo -e "${BHMagenta}--= $@ =--${ResetColor}"
}

function darkEchoH3()
{
   echo -e "${BHCyan}--- $@ ---${ResetColor}"
}

function darkEchoC1()
{
   echo -e "${HBlue}$@${ResetColor}"
}

function darkEchoC2()
{
   echo -e "${HMagenta}$@${ResetColor}"
}

function darkEchoC3()
{
   echo -e "${HCyan}$@${ResetColor}"
}

function darkEchoBold()
{
   echo -e "${Bold}$@${ResetColor}"
}

function darkEchoUnderline()
{
   echo -e "${Underline}$@${ResetColor}"
}

# Default Theme Aliases

function echoWarning()   { darkEchoWarning $@; }
function echoError()     { darkEchoError $@; }
function echoT1()        { darkEchoT1 $@; }
function echoT2()        { darkEchoT2 $@; }
function echoT3()        { darkEchoT3 $@; }
function echoH1()        { darkEchoH1 $@; }
function echoH2()        { darkEchoH2 $@; }
function echoH3()        { darkEchoH3 $@; }
function echoC1()        { darkEchoC1 $@; }
function echoC2()        { darkEchoC2 $@; }
function echoC3()        { darkEchoC3 $@; }
function echoBold()      { darkEchoBold $@; }
function echoUnderline() { darkEchoUnderline $@; }

# Test All
#
# echoWarning "Warning"
# echoError "Error"
# echoT1 "Title1"
# echoT2 "Title2"
# echoT3 "Title3"
# echoH1 "Heading1"
# echoH2 "Heading2"
# echoH3 "Heading3"
# echoC1 "Content1"
# echoC2 "Content2"
# echoC3 "Content3"
# echoBold "Bold"
# echoUnderline "Underline"
