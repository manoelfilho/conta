# conta
Conta é um app para controle financeiro que permite o cadastro de movimentações bancárias. Pode ser usado para transações de débito e crédito. As informações podem ser agrupadas por contas ou cartões e categorias. Cada conta deve ter uma cor, título e um saldo inicial. Cada categoria pode ter um símbolo (Apple SF Symbols) e um título. Cada movimentação deve estar associada a uma conta e um categoria. De modo o geral, o app permite acompanhar todas as transações bancárias de contas e cartões. 

Cada transação pode ser registrada manualmente. Se o usuário preferir pode usar o recurso de importação de extrato. Essa funcionalidade consegue importar arquivos no formato OFC, um tipo de arquivo usado para armazenar informações financeiras, geralmente utilizado pelos bancos. Dessa forma, o Extrato OFC é um extrato bancário. Para cada importação o usuário deve selecionar uma conta e uma categoria padrão. Depois de importadas, as transações pode ser modificadas e associadas a categorias diferentes. O arquivo deve estar salvo no iCloud do usuário.

Todas as informações ficam salvas no CoreData do iPhone. Nada é compartilhado na internet. Portanto, uma vez deletado do app, todas as informações també serão removidas.

## cadastrando contas
[![Watch the video](https://i.imgur.com/vKb2F1B.png)](https://youtu.be/8vQG8niHjkA)

## importando arquivos
[![Watch the video](https://i.imgur.com/vKb2F1B.png)](https://youtu.be/vKzgVmmhQxU)

| Tela inicial - Transações  | Cadastro/ Edição | Filtro |
| - | - | - |
| <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot1.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot2.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot3.PNG" alt="drawing" width="200"/> |

| Filtro por termo  | Configurações | Contas |
| - | - | - |
| <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot4.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot5.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot6.PNG" alt="drawing" width="200"/> |

| Cadastro de contas  | Categorias | Cadastro de categorias |
| - | - | - |
| <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot7.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot8.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot9.PNG" alt="drawing" width="200"/> |

| Importação de extratos  | Tela de gráficos | Gráfico detalhado |
| - | - | - |
| <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot10.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot11.PNG" alt="drawing" width="200"/> | <img src="https://github.com/manoelfilho/conta/blob/master/Preview/screenshot12.PNG" alt="drawing" width="200"/> |


### Ferramentas utilizadas

- Sketch - para o design e prototipação do app
- Photoshop - para edições de ícones e outros elementos
- XCode -  Código Swift com UIKit 


### Especificações
App desenvolvido para iPhones com iOS na versão 16.0 ou superior. Código feito de modo programático sem o uso de Storyboards e auto-layout. Segue o padrão MVP - Model View Presenter. O app usa o recurso do CoreData e salva os dados no próprio aparelho. O projeto tem como objetivo permitir a importação de extratos bancários (contas e cartões) de arquivos salvos no iCloud Drive.

### Ajustes e melhorias

O projeto ainda está em desenvolvimento e as próximas atualizações serão voltadas nas seguintes tarefas:

- [X] Tela geral de transações
- [X] Cadastro de contas
- [X] Cadastro de categorias de transações
- [X] Filtros na Tela geral de transações
- [X] Tela com gastos por contas
- [X] Importação de extratos
- [ ] Backup dos dados no iCloud Drive

## 💻 Pré-requisitos

Para executar o projeto você precisa:

* XCode na versão mais recente e simulador do iPhone
* Cocoadpods na versão mais recente


## 🚀 Instalando

Para instalar o app, siga estas etapas:

1 - Abrir a pasta do projeto no terminal:

```
cd /pasta_do_projeto

``` 
2 - Instalar as dependencias: 

```
pod install

```

Abrir o arquivo conta.xcworkspace

Executar no simulador

```
Command R

```

Para verificar dados de exemplo, crie uma conta de teste, uma categoria de teste e importe o arquivo de exemplo localizado em ExtratosExemplos/BB_extrato_exemplo.ofc. O arquivo deve estar localizado no iCloud do aparelho
