# SState

[![smalltalkCI](https://github.com/mumez/SState/actions/workflows/main.yml/badge.svg)](https://github.com/mumez/SState/actions/workflows/main.yml)

A simple Finite State Machine for Smalltalk

## Features

SState is a fairly simple FSM implementation, but is functional:

- You can add entry-action, exit-action and activity to State object.
- You can set transition action to Transition object.
- Supports guarded transition, auto transition, and decision.
- Hierarchical state machine support.
- StateMachine can handle both symbol and event object with possible arguments.

## Installation

```smalltalk
Metacello new
  baseline: 'SState';
  repository: 'github://mumez/SState/src';
  load.
```

## Example

```smalltalk
stateMachine := SsStateMachine new.

stateA := (stateMachine addStateNamed: #stateA)
    entryAction:[Transcript cr; show: 'entry stateA' ];
    exitAction:[Transcript cr; show: 'exit stateA' ];
    when: #toB to: #stateB;
    when: #toC to: #stateC.

stateB := (stateMachine addStateNamed: #stateB)
    when: #toA do: [Transcript cr; show: 'b->a'] to: #stateA.

stateC := (stateMachine addStateNamed: #stateC)
    when: #toA do: [Transcript cr; show: 'c->a'] to: #stateA;
    endWhen: #end.

stateMachine setStartStateTo: #stateA. "stateA entry-action fired"

stateMachine handleEvent: #toB. "stateA exit-action fired"
stateMachine handleEvent: #toA. "b->a transition action and stateA entry-action fired"
stateMachine handleEvent: #toC. "stateA exit-action fired"
stateMachine handleEvent: #bom. "Non-supposed events are ignored"
[stateMachine handleEvent: #boo] on: SsEventNotSupposed do: [:ex | ex inspect]. "But you can catch it if you like"
stateMachine handleEvent: #end.
stateMachine atEnd. "true"
```