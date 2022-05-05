# ===========================================================================
#   Set-Window.ps1 ----------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
Function Set-Window {
    <#
    .SYNOPSIS
    Retrieve/Set the window size and coordinates of a process window.
    
    .DESCRIPTION
    Retrieve/Set the size (height,width) and coordinates (x,y) 
    of a process window.
    
    .PARAMETER ProcessName
    
    .PARAMETER Id
    
    .PARAMETER X
    
    .PARAMETER Y
    
    .PARAMETER Width
    
    .PARAMETER Height
     
    .PARAMETER Passthru
    
    .NOTES
    Name:   Set-Window
    Author: Boe Prox
    Version History:
        1.0//Boe Prox - 11/24/2015 - Initial build
        1.1//JosefZ   - 19.05.2018 - Treats more process instances 
                                     of supplied process name properly
        1.2//JosefZ   - 21.02.2019 - Parameter Id
    Link: https://superuser.com/questions/1324007/setting-window-size-and-position-in-powershell-5-and-6

    .OUTPUTS
    None
    System.Management.Automation.PSCustomObject
    System.Object
    
    .EXAMPLE
    Get-Process powershell | Set-Window -X 20 -Y 40 -Passthru -Verbose
    VERBOSE: powershell (Id=11140, Handle=132410)
    
    Id          : 11140
    ProcessName : powershell
    Size        : 1134,781
    TopLeft     : 20,40
    BottomRight : 1154,821
    
    Description: Set the coordinates on the window for the process PowerShell.exe
    
    .EXAMPLE
    $windowArray = Set-Window -Passthru
    WARNING: cmd (1096) is minimized! Coordinates will not be accurate.
    
        PS C:\>$windowArray | Format-Table -AutoSize
    
      Id ProcessName    Size     TopLeft       BottomRight  
      -- -----------    ----     -------       -----------  
    1096 cmd            199,34   -32000,-32000 -31801,-31966
    4088 explorer       1280,50  0,974         1280,1024    
    6880 powershell     1280,974 0,0           1280,974     
    
    Description: Get the coordinates of all visible windows and save them into the $windowArray variable. Then, display them in a table view.
    
    .EXAMPLE
    Set-Window -Id $PID -Passthru | Format-Table
    ​‌‍
      Id ProcessName Size     TopLeft BottomRight
      -- ----------- ----     ------- -----------
    7840 pwsh        1024,638 0,0     1024,638
    
    Description: Display the coordinates of the window for the current 
                 PowerShell session in a table view.
    #>
    [CmdletBinding(PositionalBinding=$True, DefaultParameterSetName="Name")]

    Param (

        [Parameter(Mandatory=$False, ValueFromPipelineByPropertyName=$True, ParameterSetName="Name", HelpMessage="Name of the process to determine the window characteristics. (All processes if omitted).")]
        [String]$ProcessName="*",

        [Parameter(Mandatory=$True, ValueFromPipeline=$False,       ParameterSetName="Id", HelpMessage="Id of the process to determine the window characteristics. ")]
        [Int]$Id,

        [Parameter(HelpMessage="Set the position of the window in pixels from the left.")]
        [Int]$X,

        [Parameter(HelpMessage="Set the position of the window in pixels from the top.")]
        [Int]$Y,

        [Parameter(HelpMessage="Set the width of the window.")]
        [Int]$Width,

        [Parameter(HelpMessage="Set the height of the window.")]
        [Int]$Height,

        [Parameter(HelpMessage="Returns the output object of the window.")]
        [Switch]$Passthru
    )
    
    Begin {
        Try { 
            [Void][Window]
        } Catch {
        Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Window {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(
        IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public extern static bool MoveWindow( 
        IntPtr handle, int x, int y, int width, int height, bool redraw);

    [DllImport("user32.dll")] 
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(
        IntPtr handle, int state);
    }
    public struct RECT
    {
    public int Left;        // x position of upper-left corner
    public int Top;         // y position of upper-left corner
    public int Right;       // x position of lower-right corner
    public int Bottom;      // y position of lower-right corner
    }
"@
        }
    }

    Process {

        $Rectangle = New-Object RECT

        If ( $PSBoundParameters.ContainsKey('Id') ) {
            $Processes = Get-Process -Id $Id -ErrorAction SilentlyContinue
        } Else {
            $Processes = Get-Process -Name "$ProcessName" -ErrorAction SilentlyContinue
        }

        If ( $null -eq $Processes ) {
            If ( $PSBoundParameters['Passthru'] ) {
                Write-Warning 'No process match criteria specified'
            }
        } Else {
            $Processes | ForEach-Object {
                $Handle = $_.MainWindowHandle
                Write-Verbose "$($_.ProcessName) `(Id=$($_.Id), Handle=$Handle`)"
                If ( $Handle -eq [System.IntPtr]::Zero ) { Return }
                $Return = [Window]::GetWindowRect($Handle,[ref]$Rectangle)
                If (-NOT $PSBoundParameters.ContainsKey('X')) {
                    $X = $Rectangle.Left            
                }
                If (-NOT $PSBoundParameters.ContainsKey('Y')) {
                    $Y = $Rectangle.Top
                }
                If (-NOT $PSBoundParameters.ContainsKey('Width')) {
                    $Width = $Rectangle.Right - $Rectangle.Left
                }
                If (-NOT $PSBoundParameters.ContainsKey('Height')) {
                    $Height = $Rectangle.Bottom - $Rectangle.Top
                }
                If ( $Return ) {
                    $Return = [Window]::MoveWindow($Handle, $x, $y, $Width, $Height,$True)
                }
                If ( $PSBoundParameters['Passthru'] ) {
                    $Rectangle = New-Object RECT
                    $Return = [Window]::GetWindowRect($Handle,[ref]$Rectangle)
                    If ( $Return ) {
                        $Height      = $Rectangle.Bottom - $Rectangle.Top
                        $Width       = $Rectangle.Right  - $Rectangle.Left
                        $Size        = New-Object System.Management.Automation.Host.Size        -ArgumentList $Width, $Height
                        $TopLeft     = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Left , $Rectangle.Top
                        $BottomRight = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Right, $Rectangle.Bottom
                        If ($Rectangle.Top    -lt 0 -AND 
                            $Rectangle.Bottom -lt 0 -AND
                            $Rectangle.Left   -lt 0 -AND
                            $Rectangle.Right  -lt 0) {
                            Write-Warning "$($_.ProcessName) `($($_.Id)`) is minimized! Coordinates will not be accurate."
                        }
                        $Object = [PSCustomObject]@{
                            Id          = $_.Id
                            ProcessName = $_.ProcessName
                            Size        = $Size
                            TopLeft     = $TopLeft
                            BottomRight = $BottomRight
                        }
                        $Object
                    }
                }
            }
        }
    }
}