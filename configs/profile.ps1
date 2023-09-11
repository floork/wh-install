function Start-ElevatedSession {
  [CmdletBinding()]
  [Alias('super', 'su')]
  param(
    [Parameter(Position = 0)]
    [ValidateNotNull()]
    [scriptblock]
    $Command
  )
  $Params = @{
    FilePath = 'wt.exe'
    Wait     = $true
    Verb     = 'RunAs'
  }
  if ($PSBoundParameters.ContainsKey('Command')) {
    $Params['ArgumentList'] = '-Command', $Command
  }

  Start-Process @Params
}

# initiate starship
Invoke-Expression (&starship init powershell)
