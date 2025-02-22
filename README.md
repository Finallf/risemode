# Water Cooler Rise Mode Aura Ice Monitor no Linux

Este projeto permite o monitoramento da temperatura no Water Cooler Rise Mode Aura Ice para sistemas Linux.

## Dependências

Este script requer as seguintes dependências:
- Python 3
- `hidapi`
- `psutil`

Você pode instalar executando o script `install.sh`:

Modelos suportados:
- `Water Cooler Rise Mode Aura Ice Black 240mm ARGB - RM-WAIB-05-ARGB`
- Provavelmente funcionará nos modelos de 120mm e 360mm.

### Guia passo a passo

1. **Instalar dependências do Python**: Primeiro, você precisa instalar as bibliotecas Python necessárias, `hidapi` e `psutil`. Essas bibliotecas permitem que o script interaja com o hardware e monitore os recursos do sistema.
										
    Abra o terminal e execute os seguintes comandos:
    ```bash
    pip install hid
    pip install psutil
    ```
	Nota: Se você encontrar erros de permissão, tente adicionar --user para instalar os pacotes somente para seu usuário ou use sudo para instalá-los em todo o sistema (não recomendado para `pip`).

2. **Clone o Repositório**: O script e os arquivos de configuração necessários são hospedados no GitHub. Use o git para clonar o repositório para sua máquina local.

    ```bash
    git clone https://github.com/finallf/risemode
    ```

3. **Navegue até o Diretório do Projeto**: Mude seu diretório atual para a pasta do projeto recém-clonado.

    ```bash
    cd risemode
    ```

4. **Procure o sensor de temperatura do hardware**: Recupere o rótulo do sensor de temperatura do hardware no sistema. Execute o seguinte trecho de código Python.

	```python
    import psutil
    print(psutil.sensors_temperatures().keys())
    ```

5. **Defina qual sensor usar**: No código acima foi exibido o grupo de sensores, usaremos um deles para exibir no visor do Water Cooler.
	
	Abra o arquivo `risemode.py`
	Altere o valor da variável `SENSOR = "asus_wmi_sensors"` para um dos nomes que foram exibidos na procura do sensor e salve.
	
6. **Execute o script de instalação**: O script `install.sh` automatizará o processo de instalação. Execute o script executando:

    ```bash
    ./setup.sh
    ```

## Solução de problemas

1) Se você encontrar algum erro relacionado ao HIDAPI ou ao psutil, certifique-se de que as dependências estejam instaladas corretamente executando o script setup.sh.
2) Certifique-se de que o Water Cooler Rise Mode Aura Ice esteja conectado corretamente ao seu sistema.

Créditos:

https://github.com/raghulkrishna/deepcool-ak620-digital-linux

https://github.com/Algorithm0/deepcool-digital-info
