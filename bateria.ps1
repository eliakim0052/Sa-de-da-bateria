# --- SCRIPT DE SAÚDE DA BATERIA PERSONALIZADO (SEM VARIÁVEIS) ---
Write-Host "======= ANALISANDO A SAUDE DA BATERIA =======" -ForegroundColor Cyan

# 1. Gera o relatório na pasta temporária
powercfg /batteryreport /output "\$env:TEMP\bateria_temp.html" | Out-Null

Write-Host "`nCapacidade de Fabrica: " -NoNewline -ForegroundColor White
Write-Host "54000 mWh" -ForegroundColor Yellow

Write-Host "Capacidade Maxima Atual: " -NoNewline -ForegroundColor White
Write-Host "34980 mWh" -ForegroundColor Yellow

Write-Host "---------------------------------------------" -ForegroundColor Gray
Write-Host "A Saude da sua Bateria esta em: " -NoNewline -ForegroundColor White
Write-Host "64.78% [Regular/Moderado]" -ForegroundColor DarkYellow

Write-Host "`nEntre 60% e 79%, o estado é considerado regular/moderado (que é o caso atual da sua, em 64.78%), servindo como um sinal de alerta de que o componente já está bastante desgastado." -ForegroundColor DarkYellow

Write-Host "`n[Legenda de Referência]:" -ForegroundColor Gray

Write-Host "Porcentagem Boa: " -NoNewline -ForegroundColor Green
Write-Host "Entre 80% e 100%. Acima de 80%, o sistema entende que a bateria ainda opera com desempenho máximo e consegue segurar uma carga segura por bastante tempo fora da tomada." -ForegroundColor White

Write-Host "Porcentagem Ruim: " -NoNewline -ForegroundColor Red
Write-Host "Abaixo de 60%. Nessa faixa, a bateria já perdeu muita capacidade física, descarrega muito rápido, pode fazer o aparelho desligar sozinho de surpresa e o sistema costuma exibir avisos de manutenção ou troca urgente." -ForegroundColor White

Write-Host "`n=============================================" -ForegroundColor Cyan
