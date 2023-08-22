import React from 'react';
import dataTwentyTwo from '../data.json';
import notes from '../notes.json';
import { Modal, Button, Row, Col} from 'react-bootstrap';
import Form from 'react-bootstrap/Form';
import 'bootstrap/dist/css/bootstrap.css';


class Home extends React.Component{
    
    constructor(props, context) {
        super(props, context);
       
        //let dataObj = JSON.parse(dataTwentyTwo);
        let dataObj = dataTwentyTwo;
        
        let notesObj = notes;
        let notesMap = new Map();

        notesObj.map(note => {
            notesMap.set(note.name, note.note);
        })

        this.state = {
            notesMap: notesMap,
            isEditingNotes: false,
            currentNotePlayer: '',
            currentNote: '',
            playerSearchValue: '',
            filterPosition: 'ALL',
            dataObj: dataObj,
            showOnlyAvailable: false
        }
        
        this.openNotes = this.openNotes.bind(this);
        this.saveNote = this.saveNote.bind(this);
        this.dismissNote = this.dismissNote.bind(this);
        this.handleInputChange = this.handleInputChange.bind(this);
        this.handlePositionChange = this.handlePositionChange.bind(this);
        this.setDrafted = this.setDrafted.bind(this);
        this.toggleShowOnlyAvailable = this.toggleShowOnlyAvailable.bind(this);
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

        this.state.notesMap.set(player, note);

        let updatedNotes = [];

        for (let [key, value] of this.state.notesMap) {
            
            updatedNotes.push({"name" : key, "note" : value});
            
            console.log(key + " = " + value);
        }
        
        this.downloadToFile(JSON.stringify(updatedNotes), '2023_notes.json', 'text/plain');
        //await writeFile('C://Users//patri//Documents//Sources//fantasy-football-client//client//src//notes.json', JSON.stringify(updatedNotes));
        
        /*writeFileAtomic('C://Users//patri//Documents//Sources//fantasy-football-client//client//src//notes.json', updatedNotes, {chown:{uid:100,gid:50}}, function (err) {
            debugger;
            console.log(err);
            if (err) throw err;
            console.log('It\'s saved!');
        });*/
        
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
  

    dismissNote(){
        this.setState({
            isEditingNotes: false
        });
    }

    render(){
        
        
        

        return(
            <div className="form-inline sticky-top">
                <Form>
                    <Row>
                        <Col xs={"auto"}>
                    
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
                            <input className="form-check-input" type="checkbox" id="autoSizingCheck2" onChange={this.toggleShowOnlyAvailable} checked={this.state.showOnlyAvailable}/>
                            <label className="form-check-label" for="autoSizingCheck2">
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
                            <th scope="col">ADP</th>
                            <th scope="col">'22 Cost</th>
                            <th scope="col">'220 Drafted Team</th>
                            <th scope="col">Air Yards</th>
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
                                        
                                        if(item.is_2020_keeper === "True"){
                                            costCell = item.cost + ' (k)' 
                                        }
        
                                        let buttonText = 'Draft';
                                        let buttonClass = 'btn btn-info';

                                        if(!item.is_available){
                                            rowClassName = "keeper";
                                            buttonClass = 'btn btn-success';
                                            buttonText = "Undo";
                                        }

                                        if(item.is_2020_keeper === "True"){
                                            rowClassName = "table-danger";
                                            buttonClass = 'hidden';
                                            buttonText = '';
                                        }
                                        
                                        let note = this.state.notesMap.get(item.player_name);
                                        
                                        
                                        if(this.state.showOnlyAvailable){
                                            if(item.is_available && item.is_2020_keeper === "False"){
                                                return  <tr className={rowClassName}>
                                                    <td  className="table-col-sm" scope="row">{(i + 1)}</td>
                                                    <td>{item.player_name}</td>
                                                    <td>{item.position}</td>
                                                    <td>{item.nfl_team}</td>
                                                    <td>{item.adp}</td>
                                                    <td>{costCell}</td>
                                                    <td>{item.drafted_by}</td>
                                                    <td>{item.air_yards}</td>
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
                                            return  <tr className={rowClassName}>
                                            <td  className="table-col-sm" scope="row">{(i + 1)}</td>
                                            <td>{item.player_name}</td>
                                            <td>{item.position}</td>
                                            <td>{item.nfl_team}</td>
                                            <td>{item.adp}</td>
                                            <td>{costCell}</td>
                                            <td>{item.drafted_by}</td>
                                            <td>{item.air_yards}</td>
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