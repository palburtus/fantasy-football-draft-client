import React from 'react';
import { availableYears, getDataForYear } from '../yearData';
import { Modal, Button, Row, Col} from 'react-bootstrap';
import Form from 'react-bootstrap/Form';
import 'bootstrap/dist/css/bootstrap.css';
import * as notesRepository from '../firebaseFirestoreRepository.js';

class Home extends React.Component{
    
    constructor(props, context) {
        super(props, context);
       
        let notesMap = new Map();

        this.state = {
            notesMap: notesMap,
            isEditingNotes: false,
            currentNotePlayer: '',
            currentNote: '',
            playerSearchValue: '',
            filterPosition: 'ALL',
            activeYear: 2026,
            dataObj: getDataForYear(2026),
            showOnlyAvailable: false
        }
        
        this.openNotes = this.openNotes.bind(this);
        this.saveNote = this.saveNote.bind(this);
        this.dismissNote = this.dismissNote.bind(this);
        this.handleInputChange = this.handleInputChange.bind(this);
        this.handlePositionChange = this.handlePositionChange.bind(this);
        this.handleYearChange = this.handleYearChange.bind(this);
        this.setDrafted = this.setDrafted.bind(this);
        this.toggleShowOnlyAvailable = this.toggleShowOnlyAvailable.bind(this);
    }

    componentDidMount(){
        this.loadNotes(this.state.activeYear);
    }

    loadNotes(year){
        notesRepository.getAllNotes(year)
            .then(notes => {
                let notesMap = new Map();
        
                notes.documents.forEach(note => {
                    notesMap.set(note.playerName, note.note); 
                });
        
                this.setState({
                    notesMap: notesMap,
                    dbNotes: notes
                });
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleInputChange(event) {
       
        const target = event.target;
        const value = target.value;
        const name = target.name;
    
        this.setState({
          [name]: value,
          isError: false
        });
     }

     handlePositionChange(e){
        var position = e.target.value;
        this.setState({ filterPosition: position });
     }

      handleYearChange(e){
          const year = Number(e.target.value);

          this.setState({
                activeYear: year,
                dataObj: getDataForYear(year),
                notesMap: new Map(),
                playerSearchValue: '',
                filterPosition: 'ALL',
                showOnlyAvailable: false
          });
          this.loadNotes(year);
      }

     toggleShowOnlyAvailable(){
        
        let toggledValue = !this.state.showOnlyAvailable;

        this.setState({
            showOnlyAvailable : toggledValue
        });
     }

    openNotes(playerName, note){        
        this.setState({
            isEditingNotes: true,
            currentNotePlayer: playerName,
            currentNote: note
        });       
     
    }    

    saveNote(){
        this.setState({
            isEditingNotes: false
        });

        let note = this.state.currentNote;
        let player = this.state.currentNotePlayer;

        notesRepository.upsertNote(this.state.activeYear, player, note);

        this.state.notesMap.set(player, note);

        let updatedNotes = [];

        for (let [key, value] of this.state.notesMap) {
            
            updatedNotes.push({"name" : key, "note" : value});
            
            console.log(key + " = " + value);
        }

        
        
        //this.downloadToFile(JSON.stringify(updatedNotes), '2023_notes.json', 'text/plain');
        
    }

    downloadToFile = (content, filename, contentType) => {
        const a = document.createElement('a');
        const file = new Blob([content], {type: contentType});
        
        a.href= URL.createObjectURL(file);
        a.download = filename;
        a.click();
      
        URL.revokeObjectURL(a.href);
    };

    setDrafted(playerName){
        let data = this.state.dataObj;
        
        data.map((item, i) => {
            if(item.player_name === playerName){
                item.is_available = !item.is_available;
                
            }
        });
        
        this.setState({
            dataObj : data
        });

    }

    isKeeper(item){
        return Object.keys(item)
            .filter(key => key.endsWith('_keeper'))
            .some(key => item[key] === 'True' || item[key] === true);
    }
  

    dismissNote(){
        this.setState({
            isEditingNotes: false
        });
    }

    render(){
        
        
        

        return(
            <div className="form-inline sticky-top pinn-form">
                <Form className="draft-controls-form">
                    <Row className="draft-controls align-items-center">
                        <Col xs={"auto"} className="draft-year-control d-flex align-items-center gap-2">
                            <label className="mb-0" htmlFor="draft-year">Year</label>
                            <div className="year-select-wrapper">
                                <select id="draft-year" className="form-control" value={this.state.activeYear} onChange={this.handleYearChange}>
                                    {availableYears.map(year => <option key={year} value={year}>{year}</option>)}
                                </select>
                                <span className="year-dropdown-arrow" aria-hidden="true">&#9662;</span>
                            </div>
                        </Col>
                        <Col xs={"auto"} className="d-flex align-items-center">
                    
                         <input type="text" className="form-control" name="playerSearchValue" onChange={this.handleInputChange} placeholder="Player Name" value={this.state.playerSearchValue}/>
                   
                        </Col>
                        <Col xs={"auto"}>
                            <select className="form-control"  value={this.state.filterPosition} onChange={this.handlePositionChange }>
                                <option value="ALL">ALL</option>
                                <option value="RB">RB</option>
                                <option value="WR">WR</option>
                                <option value="QB">QB</option>
                                <option value="TE">TE</option>
                            </select>
                        </Col>
                        <Col xs={"auto"}>
                            <input className="form-check-input availability-checkbox" type="checkbox" id="autoSizingCheck2" onChange={this.toggleShowOnlyAvailable} checked={this.state.showOnlyAvailable}/>
                            <label className="form-check-label" htmlFor="autoSizingCheck2">
                            Show Available Only?
                            </label>
                        </Col>
                    </Row>
                </Form>
           
                

                <table className="table tableFixHead">
                    <thead>
                        <tr className="table-activex`">
                            <th scope="col" className="table-col-sm">#</th>
                            <th scope="col">Player</th> 
                            <th scope="col">POS</th>
                            <th scope="col">Team</th>
                            <th scope="col">Age</th>
                            <th scope="col">ADP</th>
                            <th scope="col">Air Yards</th>
                            <th scope='col'>WOPR</th>
                            <th scope="col">Rush Yards</th>
                            <th scope="col">YP Carry</th>
                            <th scope="col">TDs</th>
                            <th scope="col">Note</th>
                            <th scope="col">Actions</th>
                            <th scope="col"></th>
                        </tr>
                    </thead>
                    <tbody>
                        {
                            this.state.dataObj.map((item, i) => {
                                
                                if(item.player_name.toLowerCase().includes(this.state.playerSearchValue.toLowerCase())){
                                    
                                    if(item.position === this.state.filterPosition || this.state.filterPosition === 'ALL'){
                                        
                                        
                                        let costCell = item.cost;
                                        let rowClassName = ''
                                        
                                        if(this.isKeeper(item)){
                                            costCell = item.cost + ' (k)' 
                                        }
        
                                        let buttonText = 'Draft';
                                        let buttonClass = 'btn btn-info';

                                        if(!item.is_available){
                                            rowClassName = "keeper";
                                            buttonClass = 'btn btn-success';
                                            buttonText = "Undo";
                                        }

                                        if(this.isKeeper(item)){
                                            rowClassName = "table-danger";
                                            buttonClass = 'hidden';
                                            buttonText = '';
                                        }
                                        
                                        let note = this.state.notesMap.get(item.player_name);
                                        
                                        
                                        if(this.state.showOnlyAvailable){
                                            if(item.is_available && !this.isKeeper(item)){
                                                return  <tr key={item.player_name} className={rowClassName}>
                                                    <td  className="table-col-sm" scope="row">{item.displayRank || (i + 1)}</td>
                                                    <td>{item.player_name}</td>
                                                    <td>{item.position}</td>
                                                    <td>{item.nfl_team}</td>
                                                    <td>{item.age}</td>
                                                    <td>{item.adp}</td>
                                                    <td>{item.air_yards}</td>
                                                    <td>{item.wopr}</td>
                                                    <td>{item.rush_attempts}</td>
                                                    <td>{item.yards_per_carry}</td>
                                                    <td>{item.TDs}</td>
                                                    <td>{note}</td>
                                                    <td>
                                                        <button type="button" onClick={() => this.openNotes(item.player_name, note)} className="btn btn-info">Note</button>
                                                    </td>
                                                    <td>
                                                        <button type="button" onClick={() => this.setDrafted(item.player_name)} className={buttonClass}>{buttonText}</button>
                                                    </td>
                                                </tr>    
                                            }

                                        }else {
                                            return  <tr key={item.player_name} className={rowClassName}>
                                            <td  className="table-col-sm" scope="row">{item.displayRank || (i + 1)}</td>
                                            <td>{item.player_name}</td>
                                            <td>{item.position}</td>
                                            <td>{item.nfl_team}</td>
                                            <td>{item.age}</td>
                                            <td>{item.adp}</td>
                                            <td>{item.air_yards}</td>
                                            <td>{item.wopr}</td>
                                            <td>{item.rush_attempts}</td>
                                            <td>{item.yards_per_carry}</td>
                                            <td>{item.TDs}</td>
                                            <td>{note}</td>
                                            <td>
                                                <button type="button" onClick={() => this.openNotes(item.player_name, note)} className="btn btn-info">Note</button>
                                            </td>
                                            <td>
                                                <button type="button" onClick={() => this.setDrafted(item.player_name)} className={buttonClass}>{buttonText}</button>
                                            </td>
                                        </tr>
                                        }

                                        
                                        
                                        
                                    }
                                }
                            })
                                
                        }
                    
                    </tbody>
                </table>
                
                
                <Modal show={this.state.isEditingNotes} onHide={this.dismissNote}>
                    <Modal.Header closeButton>
                    <Modal.Title>{this.state.currentNotePlayer}</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <div className="form-group">
                            <textarea className="form-control" id="message-text" name="currentNote" value={this.state.currentNote} onChange={this.handleInputChange}/>
                        </div>
                    </Modal.Body>
                    <Modal.Footer>
                    <Button variant="secondary" onClick={this.dismissNote}>
                        Close
                    </Button>
                    <Button variant="primary" onClick={this.saveNote}>
                        Save
                    </Button>
                    </Modal.Footer>
                </Modal>
             

            </div>
        );
    }
}

export default Home;