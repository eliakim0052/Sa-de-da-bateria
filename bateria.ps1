# --- SCRIPT DE SAÚDE DA BATERIA 100% AUTOMÁTICO E UNIVERSAL ---
Write-Host "======= ANALISANDO A SAUDE DA BATERIA =======" -ForegroundColor Cyan

# 1. Gera o relatório local do notebook atual
\(ArquivoHTML = "\)env:TEMP\bateria_temp.html"
powercfg /batteryreport /output \$ArquivoHTML | Out-Null

# 2. Extrai e limpa os valores reais gerados por esta máquina
if (Test-Path \$ArquivoHTML) {
    \(Dados = Get-Content\)ArquivoHTML -Raw
    
    \(DesignStr = [regex]::Match(\)Dados, 'DESIGN CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value
    \(FullStr = [regex]::Match(\)Dados, 'FULL CHARGE CAPACITY<\/td><td class="value">([\d\s,]+)\smWh').Groups[1].Value

    \(DesignCapacity = [int](\)DesignStr -replace '[^\d]', '')
    \(FullChargeCapacity = [int](\)FullStr -replace '[^\d]', '')

    # 3. Executa o cálculo se encontrar os componentes de bateria
    if (\$DesignCapacity -gt 0 -and \(FullChargeCapacity -gt 0) {\)Porcentagem = [math]::Round((\(FullChargeCapacity / \)DesignCapacity) * 100, 2)
        
        Write-Host "`nCapacidade de Fabrica: \$DesignCapacity mWh" -ForegroundColor Yellow
        Write-Host "Capacidade Maxima Atual: \$FullChargeCapacity mWh" -ForegroundColor Yellow
        Write-Host "---------------------------------------------" -ForegroundColor Gray
        Write-Host "A Saude da sua Bateria esta em: " -NoNewline -ForegroundColor White

        # 4. Diagnóstico final com cores dinâmicas
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
        Write-Host "`nNao foi possivel ler os dados de mWh. Certifique-se de que este aparelho e um notebook." -ForegroundColor Red
    }
} else {
    Write-Host "`nErro ao criar o relatorio de bateria local." -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Cyan
