######################################################################################
# GIPHY-Linker V1.0 - Released 28/02/2024                                            #
#                                                                                    #
# Script Created by ReproDev:   https://github.com/reprodev/GIPHY=Linker/            #
# Released Under MIT Licence                                                         # 
# Check out other projects :    https://github.com/reprodev/                         #
# Why not buy me a coffee? :    https://ko-fi.com/reprodev                           #
#                                                                                    #
######################################################################################

# Call the GUI elements
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Minimize the PowerShell console window
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class ConsoleWindow {
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        public static void Minimize() {
            IntPtr consoleWindow = System.Diagnostics.Process.GetCurrentProcess().MainWindowHandle;
            const int SW_MINIMIZE = 6;
            ShowWindow(consoleWindow, SW_MINIMIZE);
        }
    }
"@

# Call the Minimize method to minimize the console window
[ConsoleWindow]::Minimize()

# Setup the form window
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'GIPHY Linker'
$form.Size = New-Object System.Drawing.Size(400,245)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog' # Prevent resizing
$form.MaximizeBox = $false # Disable maximize button

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Paste the "Copy GIF Link" from GIPHY.com'
$form.Controls.Add($label)

# Instructions Button
$instructionButton = New-Object System.Windows.Forms.Button
$instructionButton.Location = New-Object System.Drawing.Point(210,175)
$instructionButton.Size = New-Object System.Drawing.Size(90,23)
$instructionButton.Text = 'Instructions'
$form.Controls.Add($instructionButton)

$inputTextbox = New-Object System.Windows.Forms.TextBox
$inputTextbox.Location = New-Object System.Drawing.Point(10,30)
$inputTextbox.Size = New-Object System.Drawing.Size(360,20)
$form.Controls.Add($inputTextbox)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,60)
$button.Size = New-Object System.Drawing.Size(200,23)
$button.Text = 'Convert into Markdown with HTML'
$form.Controls.Add($button)

$outputTextbox = New-Object System.Windows.Forms.TextBox
$outputTextbox.Location = New-Object System.Drawing.Point(10,90)
$outputTextbox.Size = New-Object System.Drawing.Size(360,80)
$outputTextbox.Multiline = $true
$outputTextbox.ScrollBars = 'Vertical'
$outputTextbox.ReadOnly = $true
$form.Controls.Add($outputTextbox)

$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Location = New-Object System.Drawing.Point(10,175)
$copyButton.Size = New-Object System.Drawing.Size(90,23)
$copyButton.Text = 'Copy HTML'
$form.Controls.Add($copyButton)

# Clear Button
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Location = New-Object System.Drawing.Point(110,175)
$clearButton.Size = New-Object System.Drawing.Size(90,23)
$clearButton.Text = 'Clear'
$form.Controls.Add($clearButton)

# About Button
$aboutButton = New-Object System.Windows.Forms.Button
$aboutButton.Location = New-Object System.Drawing.Point(310,175)
$aboutButton.Size = New-Object System.Drawing.Size(60,23)
$aboutButton.Text = 'About'
$form.Controls.Add($aboutButton)

$generateHtmlAction = {
    $GiphyAdd = $inputTextbox.Text
    $html = "<img width=`"100%`" style=`"width:100%`" src=`"$GiphyAdd`">"
    $outputTextbox.Text = $html
}

$button.Add_Click($generateHtmlAction)

$copyButton.Add_Click({
    [System.Windows.Forms.Clipboard]::SetText($outputTextbox.Text)
})

$clearButton.Add_Click({
    $inputTextbox.Clear()
    $outputTextbox.Clear()
})

$instructionAction = {
    $message = "How to use GIPHY Linker:`n`n" +
               "- Go to giphy.com or your fave GIF site and find a GIF.`n" +
               "- Click Share on the GIF and copy the 'Copy GIF Link'.`n" +
               "- Paste the link into the box in GIPHY Linker.`n" +
               "- Click 'Convert into Markdown with HTML' to create the HTML code for your Blog with your chosen GIF.`n" +
               "- Use 'Copy HTML' to copy the link to your clipboard.`n" +
               "- Paste your HTML line of code into your blog.`n" +
               "- Use 'Clear' to reset the form and start again."
    [System.Windows.Forms.MessageBox]::Show($message, "GIPHY Linker Instructions")
}

$instructionButton.Add_Click($instructionAction)

$aboutAction = {
    $aboutForm = New-Object System.Windows.Forms.Form
    $aboutForm.Size = New-Object System.Drawing.Size(270,200)
    $aboutForm.StartPosition = 'CenterScreen'
    $aboutForm.Text = 'About'
    $aboutform.FormBorderStyle = 'FixedDialog'
    $aboutform.MaximizeBox = $false
    $aboutform.MinimizeBox = $false

    $aboutLabel = New-Object System.Windows.Forms.Label
    $aboutLabel.Location = New-Object System.Drawing.Point(10,10)
    $aboutLabel.Size = New-Object System.Drawing.Size(280,120)
    $aboutLabel.Text = "GIPHY Linker`n" +
                       "`n" +
                       "Version: 1.0a`n" +
                       "`n" +
                       #"Release Date: 2024-02-27`n" +
                       "Developed by: ReproDev`n" +
                       "`n" +
                       "Contact: info@reprodev.com`n" +
                       "`n" +
                       "For updates and more projects visit my GitHub"
    $aboutForm.Controls.Add($aboutLabel)

    $linkLabel = New-Object System.Windows.Forms.LinkLabel
    $linkLabel.Location = New-Object System.Drawing.Point(10,128)
    $linkLabel.Size = New-Object System.Drawing.Size(280,80)
    $linkLabel.Text = 'https://github.com/reprodev/'

    # Clear existing links to prevent overlap error
    $linkLabel.Links.Clear()
    
    # Now add the link
    $linkLabel.LinkArea = New-Object System.Windows.Forms.LinkArea(0, $linkLabel.Text.Length)
    $linkLabel.Links.Add(0, $linkLabel.Text.Length, 'https://github.com/reprodev/') # Link data

    $linkLabel.Add_LinkClicked({
        param($sender, $e)
        Start-Process $e.Link.LinkData
    })

    $aboutForm.Controls.Add($linkLabel)
    $aboutForm.ShowDialog()
}


$aboutButton.Add_Click($aboutAction)

$inputTextbox.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq 'Return') {
        $generateHtmlAction.Invoke()
    }
})

$form.ShowDialog()
