Write-Host "======= ANALISANDO A SAUDE DA BATERIA =======" -ForegroundColor Cyan

\$CaminhoHTML = "bateria_temp.html"
powercfg /batteryreport /output \$CaminhoHTML | Out-Null

if (Test-Path \$CaminhoHTML) {
    Relatorio = Get-Content CaminhoHTML -Raw

    \(DesignStr = [regex]::Match(\)Relatorio, 'DESIGN CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value
    \(FullStr = [regex]::Match(\)Relatorio, 'FULL CHARGE CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value

    \(DesignCap = [int](\)DesignStr -replace '[^\d]', '')
    \(FullCap = [int](\)FullStr -replace '[^\d]', '')

    if (\$DesignCap -gt 0 -and \(FullCap -gt 0) {\)Porcentagem = [math]::Round((FullCap / DesignCap) * 100, 2)

        Write-Host ""
        Write-Host "Capacidade de Fabrica: \$DesignCap mWh" -ForegroundColor Yellow
        Write-Host "Capacidade Maxima Atual: \$FullCap mWh" -ForegroundColor Yellow
        Write-Host "---------------------------------------------" -ForegroundColor Gray
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
    } else {
        Write-Host "`nNao foi possivel extrair os valores de capacidade. Certifique-se de que este aparelho e um notebook." -ForegroundColor Red
    }
    Remove-Item \$CaminhoHTML -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "`nErro ao criar o relatorio de bateria local." -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Cyan
