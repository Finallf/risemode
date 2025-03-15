# Water Cooler Rise Mode Aura Ice Monitor no Linux

Este projeto permite o monitoramento da temperatura no Water Cooler Rise Mode Aura Ice para sistemas Linux.

## Dependências

Este script requer as seguintes dependências:
- lm-sensors

Você pode instalar executando o script `install.sh`:

Modelos suportados:
- `Water Cooler Rise Mode Aura Ice Black 240mm ARGB - RM-WAIB-05-ARGB`
- Provavelmente funcionará nos modelos de 120mm e 360mm.

### Guia passo a passo

1. **Instalar dependências**: Primeiro, você precisa instalar o pacote necessário `lm-sensors`. Esse pacote permitem que o script efetue a leitura de temperatura e monitore os recursos do sistema.
										
    Abra o terminal e execute os seguintes comandos:
    ```bash
    apt-get install lm-sensors
    ```
	Nota: Se você encontrar erros de permissão, use sudo para instalá-lo em todo o sistema.

2. **Clone o Repositório**: O script e os arquivos de configuração necessários são hospedados no GitHub. Use o git para clonar o repositório para sua máquina local.

    ```bash
    git clone https://github.com/finallf/risemode
    ```

3. **Navegue até o Diretório do Projeto**: Mude seu diretório atual para a pasta do projeto recém-clonado.

    ```bash
    cd risemode
    ```

4. **Execute o script de instalação**: O script `install.sh` automatizará o processo de instalação. Execute o script executando:

    ```bash
    ./install.sh
    ```

## Solução de problemas

1) Se você encontrar algum erro relacionado as temperaturas, certifique-se de que o pacote lm-sensors esteja instalado corretamente.
2) Certifique-se de que o Water Cooler Rise Mode Aura Ice esteja conectado corretamente ao seu sistema.