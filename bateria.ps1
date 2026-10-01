Write-Host "======= ANALISANDO A SAUDE DA BATERIA =======" -ForegroundColor Cyan

powercfg /batteryreport /output "\$env:TEMP\bateria_temp.html" | Out-Null

if (Test-Path "\$env:TEMP\bateria_temp.html") {
    Set-Variable -Name "Relatorio" -Value (Get-Content "\$env:TEMP\bateria_temp.html" -Raw)
    
    Set-Variable -Name "DesignStr" -Value ([regex]::Match((gv Relatorio).Value, 'DESIGN CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value)
    Set-Variable -Name "FullStr" -Value ([regex]::Match((gv Relatorio).Value, 'FULL CHARGE CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value)

    Set-Variable -Name "DesignCap" -Value ([int]((gv DesignStr).Value -replace '[^\d]', ''))
    Set-Variable -Name "FullCap" -Value ([int]((gv FullStr).Value -replace '[^\d]', ''))

    if ((gv DesignCap).Value -gt 0 -and (gv FullCap).Value -gt 0) {
        Set-Variable -Name "Porcentagem" -Value ([math]::Round(((gv FullCap).Value / (gv DesignCap).Value) * 100, 2))

        Write-Host "`nCapacidade de Fabrica: \$((gv DesignCap).Value) mWh" -ForegroundColor Yellow
        Write-Host "Capacidade Maxima Atual: \$((gv FullCap).Value) mWh" -ForegroundColor Yellow
        Write-Host "---------------------------------------------" -ForegroundColor Gray
        Write-Host "A Saude da sua Bateria esta em: " -NoNewline -ForegroundColor White

        if ((gv Porcentagem).Value -ge 80) {
            Write-Host "\$((gv Porcentagem).Value)% [Porcentagem Boa]" -ForegroundColor Green
            Write-Host "`nAcima de 80%, o sistema entende que a bateria ainda opera com desempenho maximo e consegue segurar uma carga segura por bastante tempo fora da tomada." -ForegroundColor Green
        }
        elseif ((gv Porcentagem).Value -ge 60) {
            Write-Host "$((gv Porcentagem).Value)% [Regular/Moderado]" -ForegroundColor DarkYellow
            Write-Host "`nEntre 60% e 79%, o estado e considerado regular/moderado (que e o caso atual da sua, em \$((gv Porcentagem).Value)%), servindo como um sinal de alerta de que o componente ja esta bastante desgastado." -ForegroundColor DarkYellow
        }
        else {
            Write-Host "\$((gv Porcentagem).Value)% [Porcentagem Ruim]" -ForegroundColor Red
            Write-Host "`nAbaixo de 60%. Nessa faixa, a bateria ja perdeu muita capacidade fisica, descarrega muito rapido, pode fazer o aparelho desligar sozinho de surpresa e o sistema costuma exibir avisos de manutencao ou troca urgente." -ForegroundColor Red
        }
    } else {
        Write-Host "`nNao foi possivel extrair os valores de capacidade. Certifique-se de que este aparelho e um notebook." -ForegroundColor Red
    }
} else {
    Write-Host "`nErro ao criar o relatorio de bateria local." -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Cyan
