Write-Host "======= ANALISANDO A SAUDE DA BATERIA =======" -ForegroundColor Cyan

powercfg /batteryreport /output "\$env:TEMP\bateria_temp.html" | Out-Null

Relatorio = Get-Content "env:TEMP\bateria_temp.html" -Raw

\(DesignCap = [int]([regex]::Match(\)Relatorio, 'DESIGN CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value -replace '[^\d]', '')
\(FullCap = [int]([regex]::Match(\)Relatorio, 'FULL CHARGE CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value -replace '[^\d]', '')

Write-Host "`nCapacidade de Fabrica: \$DesignCap mWh" -ForegroundColor Yellow
Write-Host "Capacidade Maxima Atual: \$FullCap mWh" -ForegroundColor Yellow
Write-Host "---------------------------------------------" -ForegroundColor Gray

\$Porcentagem = [math]::Round((FullCap / DesignCap) * 100, 2)

Write-Host "A Saude da sua Bateria esta em: " -NoNewline -ForegroundColor White

if (\$Porcentagem -ge 80) {
    Write-Host "\$Porcentagem% [Porcentagem Boa]" -ForegroundColor Green
    Write-Host "`nAcima de 80%, o sistema entende que a bateria ainda opera com desempenho maximo e consegue segurar uma carga segura por bastante tempo fora da tomada." -ForegroundColor Green
}
elseif ($Porcentagem -ge 60) {
    Write-Host "$Porcentagem% [Regular/Moderado]" -ForegroundColor DarkYellow
    Write-Host "`nEntre 60% e 79%, o estado e considerado regular/moderado (que e o caso atual da sua, em \$Porcentagem%), servindo como um sinal de alerta de que o componente ja esta bastante desgastado." -ForegroundColor DarkYellow
}
else {
    Write-Host "\$Porcentagem% [Porcentagem Ruim]" -ForegroundColor Red
    Write-Host "`nAbaixo de 60%. Nessa faixa, a bateria ja perdeu muita capacidade fisica, descarrega muito rapido, pode fazer o aparelho desligar sozinho de surpresa e o sistema costuma exibir avisos de manutencao ou troca urgente." -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Cyan
