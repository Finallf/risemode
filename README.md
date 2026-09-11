# Water Cooler Rise Mode Aura Ice Monitor no Linux

Este projeto permite o monitoramento da temperatura no mostrador (display) do Water Cooler Rise Mode Aura Ice para sistemas Linux.

## Dependências

- **Nenhuma dependência externa obrigatória.** O script lê os sensores diretamente via interface nativa do kernel Linux (`/sys/class/hwmon` e `/sys/class/thermal`).
- *(Opcional)* `lm-sensors`: Utilizado apenas como mecanismo de fallback para placas ou módulos legados/proprietários que não expõem a interface padrão no sysfs.

### Modelos testados:
- Water Cooler Rise Mode Aura Ice Black 120mm ARGB - RM-WAIB-04-ARGB: `?`
- Water Cooler Rise Mode Aura Ice Black 240mm ARGB - RM-WAIB-05-ARGB: `Ok`
- Water Cooler Rise Mode Aura Ice Black 360mm ARGB - RM-WAIB-06-ARGB: `Ok`

## Guia passo a passo

### Instalação

1. **Clone o Repositório**: O script e os arquivos de configuração necessários são hospedados no GitHub. Use o git para clonar o repositório para sua máquina local.

    ```bash
    git clone https://github.com/finallf/risemode
    ```

2. **Navegue até o Diretório**: Mude seu diretório atual para a pasta do projeto recém-clonado.

    ```bash
    cd risemode
    ```

3. **Teste em sua máquina**: Execute o diagnóstico e verifique a saída exibida.

    ```bash
    ./risemode.sh
    ```
    * Será exibido um diagnóstico das detecções efetuadas. Caso a temperatura não tenha sido detectada, tente instalar o pacote lm-sensors.

4. **Execute o script de instalação**: O script `install.sh` executará o processo de instalação no sistema.

    ```bash
    sudo ./install.sh
    ```
    * O mostrador deve exibir a temperatura imediatamente e ser atualizado a cada 2s.
  
5. **(Opcional) Instalar lm-sensors**: Necessário apenas se sua placa-mãe não expuser os sensores de CPU no sysfs padrão:
    ```bash
    sudo apt-get install lm-sensors
    ```

### Desinstalação

1. **Execute o script de desinstalação**: O script `uninstall.sh` executará o processo de remoção do sistema.

    ```bash
    sudo ./uninstall.sh
    ```
    * O mostrador deve apagar em alguns segundos.

### Solução de problemas

1) Se você encontrar algum erro relacionado as temperaturas, tente instalar o pacote lm-sensors.
2) Certifique-se de que o Water Cooler Rise Mode Aura Ice esteja conectado corretamente à conexão USB do seu sistema.
3) Certifique-se que os arquivos install.sh e risemode.sh tem permissão de execução.
